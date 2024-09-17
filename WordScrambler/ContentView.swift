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
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Enter you word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWords, id: \.self){ word in
                        HStack{
                            Text("") // количество букв каунт и циркле ( круг )
                            Text("\(word)")
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
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
                return
            }
        }
        
        fatalError(" Could not load start.txt from boundle. ")
    }
}

#Preview {
    ContentView()
}
