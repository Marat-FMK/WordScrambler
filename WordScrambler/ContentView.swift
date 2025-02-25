//
//  ContentView.swift
//  WordScrambler
//
//  Created by Marat Fakhrizhanov on 17.09.2024.
//

import SwiftUI

struct ContentView: View {
   
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private var result: Int {
        usedWords.count
    }
    
    var body: some View {
        NavigationStack{
            
            Text("Score ")
                .foregroundStyle(.blue)
                .font(.largeTitle)
                .padding()
                .background(Color.red)
                .clipShape(Capsule())
                
            Text("\(result)")
                .font(.largeTitle)
                .foregroundStyle(.purple)
            
            List{
                Section{
                    TextField("Enter you word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWords, id: \.self){ word in
                        HStack{
                            Image(systemName: "\(word.count).circle.fill" )
                            Text("\(word)")
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("New word", action: startGame)
            }
        }
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPosible(word: answer) else {
            wordError(title: "Word not possible", message: "You cant spell that word from '\(rootWord)' ! ")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "Tou can't just make them up, you know!")
            return
        }
        
        guard someCheck() else {
            wordError(title: "Error input", message: "word must be 4 letter and more^ root word dont take")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") { // ищем путь (ЮРЛ)
            if let startWords = try? String(contentsOf: startWordsURL){ // Извлекаем строки из ТХТ
                let allWords = startWords.components(separatedBy: "\n")// Унас в файле все с новой строки , поэтому тут каждый элемент добавляем в массив- каждый эл-т до переноса каретки
                rootWord = allWords.randomElement() ?? "silkworm" // берем любое слово из массива
               // usedWords.removeAll() // Если надо очистиьть результаты после предидущего слова
                return
            }
        }
        
        fatalError(" Could not load start.txt from boundle. ")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPosible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRanged = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRanged.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func someCheck() -> Bool {
        if newWord != rootWord && newWord.count > 3 {
            return true
        }
        return false
    }
}

#Preview {
    ContentView()
}
