//
//  HomeViewModel.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var lastChecked: Date = Date.now
    
    @Published var softwareSearchText: String = ""
    @Published var policySearchText: String = ""
    @Published var issueSearchText: String = ""
    
    @Published var deviceDetails: DeviceModel? = nil
    @Published var configuration: Configuration? = nil
    @Published var network: NetworkModel? = nil
    @Published var software: [SoftwareModel] = []
    @Published var issues: [Policy] = []
    @Published var policies: [Policy] = []
    
    private let deviceDetailService = DeviceDetailService()
    private let configurationDetailService = ConfigurationDetailService()
    private let networkDetailService = NetworkDetailService()
    private let softwareDetailService = SoftwareDetailService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    private func addSubscribers() {
        deviceDetailService.$deviceDetails
            .sink { [weak self] deviceDetails in
                self?.deviceDetails = deviceDetails
            }
            .store(in: &cancellables)
        configurationDetailService.$configuration
            .sink { [weak self] configurationDetails in
                self?.setConfiguration(configuration: configurationDetails)
            }
            .store(in: &cancellables)
        networkDetailService.$networkModel
            .sink { [weak self] networkModel in
                self?.network = networkModel
            }
            .store(in: &cancellables)
        $policySearchText
            .combineLatest(configurationDetailService.$configuration)
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink {[weak self] (text, configuration) in
                self?.filterPolicies(text: text, configuration: configuration)
            }
            .store(in: &cancellables)
        $issueSearchText
            .combineLatest(configurationDetailService.$configuration)
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] (text, configuration) in
                self?.filterIssues(text: text, configuration: configuration)
            }
            .store(in: &cancellables)
        $softwareSearchText
            .combineLatest(softwareDetailService.$software)
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .map(filterSoftware)
            .sink { [weak self] softwareDetails in
                self?.software = softwareDetails
            }
            .store(in: &cancellables)
    }
    func checkPolicies() {
        configurationDetailService.checkPolicies()
    }
    func refetchConfiguration() {
        configurationDetailService.loadConfiguration()
    }
    func refetchDeviceDetails() {
        deviceDetailService.fetchDeviceDetails()
    }
    func refetchNetworkDetails() {
        networkDetailService.fetchNetworkDetails()
    }
    func refetchSoftwareDetails() {
        softwareDetailService.fetchSoftwareDetails()
    }
    func refetchDetails() {
        self.lastChecked = Date.now
        self.refetchConfiguration()
        self.refetchNetworkDetails()
        self.refetchSoftwareDetails()
        self.checkPolicies()
        self.sendIssueNotification()
    }
    func sendIssueNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.issues.count > 0 {
                let title = "Issues affecting laptop"
                let subtitle = "\(self.issues.count) issues require attention. Click the fix button to remediate."
                NotificationManager.instance.sendButtonNotification(title: title, subtitle: subtitle, button: .fix)
            }
        }
    }
    private func setConfiguration(configuration: Configuration?) {
        self.configuration = configuration
        self.policies = configuration?.policies ?? []
        self.issues = configuration?.policies.filter { $0.status == .unhealthy } ?? []
    }
    private func filterPolicies(text: String, configuration: Configuration?) {
        guard !text.isEmpty else {
            self.policies = configuration?.policies.sorted { ($0.status == .unhealthy) && ($1.status != .unhealthy) } ?? []
            return
        }
        let lowercasedText = text.lowercased()
        self.policies = configuration?.policies.filter { ($0.title.lowercased().contains(lowercasedText) || $0.query.lowercased().contains(lowercasedText)) } ?? []
    }
    private func filterIssues(text: String, configuration: Configuration?) {
        guard !text.isEmpty else {
            self.issues = configuration?.policies.filter { $0.status == .unhealthy } ?? []
            return
        }
        let lowercasedText = text.lowercased()
        self.issues = configuration?.policies.filter { ($0.status == .unhealthy) && ($0.title.lowercased().contains(lowercasedText) || $0.query.lowercased().contains(lowercasedText)) } ?? []
    }
    private func filterSoftware(text: String, softwareDetails: [SoftwareModel]) -> [SoftwareModel] {
        guard !text.isEmpty else {
            return softwareDetails
        }
        let lowercasedText = text.lowercased()
        return softwareDetails.filter { (software) -> Bool in
            software.name.lowercased().contains(lowercasedText) ||
            software.path.lowercased().contains(lowercasedText) ||
            software.displayName.lowercased().contains(lowercasedText)
        }
    }
}
