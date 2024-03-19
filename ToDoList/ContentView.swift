import SwiftUI

struct ContentView: View {
    @State var toDo = ["go", "sit", "sleep"]
    @State var checkedItems: Set<Int> = []
    @State private var checkSheet = false
    @State var newNote = ""
    
    
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("Add") {
                    checkSheet = true
                }
                .padding()
                .sheet(isPresented: $checkSheet) {
                    VStack {
                        Spacer()
                        TextField("New Note", text: $newNote)
                        Spacer()
                        Button("Add Note") {
                            
                            if newNote != "" {
                                toDo.append(newNote)
                            }
                            UserDefaults.standard.set(toDo, forKey: "ToDoList")
                            newNote = "" // Notu ekledikten sonra textField'i temizle
                            checkSheet = false
                        }
                    }
                    .padding()
                }
            }
            NavigationStack {
                List {
                    ForEach(toDo.indices, id: \.self) { index in
                        HStack {
                            Text(toDo[index])
                            Spacer().onTapGesture {
                                if checkedItems.contains(index) {
                                    checkedItems.remove(index)
                                } else {
                                    checkedItems.insert(index)
                                }
                                
                            }
                            if checkedItems.contains(index) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture {
                            if checkedItems.contains(index) {
                                checkedItems.remove(index)
                            } else {
                                checkedItems.insert(index)
                            }
                            UserDefaults.standard.set(Array(checkedItems), forKey: "CheckedItems")
                        }
                    }
                    .onDelete(perform: delete)
                }.navigationTitle("To Do List")
            }
            
        }.onAppear(perform: {
            if let tempList = UserDefaults.standard.stringArray(forKey: "ToDoList"){
                toDo = tempList
            }
            if let temp = UserDefaults.standard.array(forKey: "CheckedItems") as? [Int] {
                checkedItems = Set(temp)
            }
            
        })
    }
    
    func delete(at offsets: IndexSet) {
        toDo.remove(atOffsets: offsets)
        UserDefaults.standard.set(toDo, forKey: "ToDoList")
        
       
        
    }
}
    
    
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

