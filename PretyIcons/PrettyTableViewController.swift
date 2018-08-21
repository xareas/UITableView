import UIKit

class PrettyTableViewController: UITableViewController {

    var iconsSets = [IconSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         iconsSets = IconSet.iconSets()
         self.navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         return iconsSets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let increment = isEditing ? 1 : 0
        return iconsSets[section].icons.count + increment
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconSet = iconsSets[indexPath.section]
       
        
        if indexPath.row >= iconSet.icons.count && isEditing{
            cell.textLabel?.text = "Agregar Icono"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            let icon = iconsSets[indexPath.section].icons[indexPath.row]
            cell.textLabel?.text = icon.title
            cell.detailTextLabel?.text = icon.subtitle
            if let iconImage = icon.image {
                cell.imageView?.image = iconImage
            } else {
                cell.imageView?.image = nil
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return  iconsSets[section].name
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            tableView.beginUpdates()
            for (index,set) in iconsSets.enumerated(){
                let indexPath = IndexPath(row: set.icons.count, section: index)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        }
        else {
            tableView.beginUpdates()
            for (index,set) in iconsSets.enumerated(){
                let indexPath = IndexPath(row: set.icons.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            
            tableView.setEditing(false, animated: true)
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            iconsSets[indexPath.section].icons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           let newIcon = Icon(withTitle: "Nuevo Bugs", subtitle: "Nuevo Elemento", imageName: nil)
            let set = iconsSets[indexPath.section]
            set.icons.append(newIcon)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceSet = iconsSets[sourceIndexPath.section]
        let destinationSet = iconsSets[destinationIndexPath.section]
        let iconToMove = sourceSet.icons[sourceIndexPath.row]
        
        
        if sourceSet == destinationSet {
            if destinationIndexPath.row != sourceIndexPath.row {
               destinationSet.icons.swapAt(destinationIndexPath.row, sourceIndexPath.row)
             }
        } else {
            
            destinationSet.icons.insert(iconToMove, at: destinationIndexPath.row)
            sourceSet.icons.remove(at: sourceIndexPath.row)
        }
        
        
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let set = iconsSets[proposedDestinationIndexPath.section]
        
        if proposedDestinationIndexPath.row >= set.icons.count {
            return IndexPath(row: set.icons.count - 1 , section: proposedDestinationIndexPath.section)
        }
        
        return proposedDestinationIndexPath
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        let iconSet = iconsSets[indexPath.section]
        if indexPath.row >= iconSet.icons.count && isEditing {
            return false
        }
        return true
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Metodos de UITableViewDelegate
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let set = iconsSets[indexPath.section]
        if indexPath.row >= set.icons.count{
            return .insert
        }
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let set = iconsSets[indexPath.section]
        if isEditing && indexPath.row < set.icons.count {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let set = iconsSets[indexPath.section]
        if indexPath.row >= set.icons.count && isEditing{
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }

}
