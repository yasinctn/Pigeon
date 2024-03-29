//
//  ConversationsViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol ConversationsViewInput: AnyObject {
    func reloadData()
    func showAlert(_ message: String)
    func goToEntryScreen()
}

final class ConversationsViewController: UIViewController {

    @IBOutlet private weak var conversationsTableView: UITableView!
    
    private var viewModel: ConversationsViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ConversationsViewModel(view: self)
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getConversations()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        viewModel?.logout()
    }
    
    @IBAction private func newConversationButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(identifier: "goToSelectUser")
    }
}

// MARK: - TableViewDataSource

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.conversationCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        if let conversation = viewModel?.getConversation(indexPath.row) {
            cell.configure(for: UserCellPresenter(conversationID: conversation.conversationID, user: conversation.receiver))
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension ConversationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelectedConversation(by: indexPath.row)
        performSegue(identifier: "conversationsToChat")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conversationsToChat" {
            let destination = segue.destination as! ChatViewController
            
            destination.currentConversation = viewModel?.selectedConversation
        }
    }
}

// MARK: - ConversationViewInput

extension ConversationsViewController: ConversationsViewInput, AlertPresentable, SeguePerformable {
    
    func reloadData() {
        conversationsTableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
    func goToEntryScreen() {
        popToRootViewControllerWithAlert(alertTitle: "Logout Success", actionTitle: "Close")
    }
}

// MARK: - Private Methods

private extension ConversationsViewController {
    
    func prepareTableView() {
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
}


