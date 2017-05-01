
import UIKit

struct TableCellDescriptor {
    let cellClass: UITableViewCell.Type
    let reuseIdentifier: String
    let configureCell: (UITableViewCell) -> ()
    
    init<Cell: UITableViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> ()) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configureCell = { cell in
            configure(cell as! Cell)
        }
    }
}

class GenericTableViewController<Item>: UITableViewController {
    //MARK: Var
    var items: [[Item]] = []
    var reuseIdentifiers: Set<String> = []
    var headerTitles: [String]?
    
    //MARK: Closures
    let cellDescriptor: (Item) -> TableCellDescriptor
    var didSelect: (Item) -> () = { _ in }
    
    init(items: [[Item]], cellDescriptor: @escaping (Item) -> TableCellDescriptor) {
        self.cellDescriptor = cellDescriptor
        super.init(style: .plain)
        self.items = items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: delegation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        didSelect(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        let descriptor = cellDescriptor(item)
        
        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            tableView.register(UINib.init(nibName: descriptor.reuseIdentifier, bundle: nil), forCellReuseIdentifier: descriptor.reuseIdentifier)
            reuseIdentifiers.insert(descriptor.reuseIdentifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configureCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return items.count > 1 ? 50 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerTitles = headerTitles else { return nil }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.attributedText = NSAttributedString.indentString(text: headerTitles[section], val: 13)
        label.textColor = .darkGray
        label.backgroundColor = tableView.backgroundColor
        return label
    }
}

