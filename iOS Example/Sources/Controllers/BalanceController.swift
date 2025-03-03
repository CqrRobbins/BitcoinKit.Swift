import Combine
import UIKit

class BalanceController: UITableViewController {
    private var cancellables = Set<AnyCancellable>()
    private var adapterCancellables = Set<AnyCancellable>()

    private var adapter: BaseAdapter?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(start))

        tableView.register(UINib(nibName: String(describing: BalanceCell.self), bundle: Bundle(for: BalanceCell.self)), forCellReuseIdentifier: String(describing: BalanceCell.self))
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero

        tableView.estimatedRowHeight = 0

        Manager.shared.adapterSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.updateAdapters()
                }
                .store(in: &cancellables)

        updateAdapters()
    }

    private func updateAdapters() {
        adapter = Manager.shared.adapter
        tableView.reloadData()

        adapterCancellables = Set()

        if let adapter = Manager.shared.adapter {
            Publishers.MergeMany(adapter.lastBlockPublisher, adapter.syncStatePublisher, adapter.balancePublisher)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.update()
                    }
                    .store(in: &adapterCancellables)
        }
    }

    @objc func logout() {
        Manager.shared.logout()

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = UINavigationController(rootViewController: WordsController())
            })
        }
    }

    @objc func start() {
        Manager.shared.adapter?.start()
        if let button = navigationItem.rightBarButtonItem {
            button.title = "Refresh"
            button.action = #selector(refresh)
        }
    }

    @objc func refresh() {
        Manager.shared.adapter?.refresh()
    }

    @IBAction func showDebugInfo() {
//        print(Manager.shared.ethereumKit.debugInfo)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: BalanceCell.self), for: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? BalanceCell, let adapter = adapter {
            cell.bind(adapter: adapter)
        }
    }

    private func update() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        print(adapter?.waitConfirmSpendableBlance, "---->")
        if let transactions = adapter?.transactions(fromUid: nil, type: .incoming, limit: 500), let lastH = adapter?.lastBlockInfo?.height {
            let ss = transactions.filter({lastH - ($0.blockHeight ?? 0) < 5})
            let value = ss.map {$0.amount}
            let blockH = ss.map({$0.blockHeight})
            print(value, blockH, lastH)
        }
    }

}
