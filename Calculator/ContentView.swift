import SwiftUI

struct Calculator: View {
    @State var inputText: String = "0"
    @State var isTypingNumber: Bool = false
    
    let button: [[String]] = [["AC", "+/-", "%", "÷"],["7", "8", "9", "×"],
                              ["4", "5", "6", "-"],["1", "2", "3", "+"],["0", ".", "="]]

    var body: some View {
        VStack(spacing: 10){
            Spacer()
            HStack{
                Spacer()
                Text(inputText)
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .padding()
                    .lineLimit(3)
                    .multilineTextAlignment(.trailing)
            }
            
            ForEach(button, id: \ .self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \ .self) { inputButton in
                        let isWide = inputButton == "0"
                        ButtonDesin(title: inputButton, isWide: isWide){
                            self.buttonPressed(inputButton)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 40)
        .ignoresSafeArea(edges:.all)
        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
        .background(Color.black)
        
    }

    //MARK: - buttonPressed
    func buttonPressed(_ button: String) {
        if let _ = Double(button) {
            numPressed(button)
        } else {
            switch button {
            case "AC": clearAll()
            case "+/-": toggleSign()
            case "%": percentage()
            case "=": calResult()
            case ".", "+", "-", "×", "÷": addSymbol(button)
            default: break
            }
        }
    }

    func numPressed(_ num: String) {
        if isTypingNumber {
            inputText += num
        } else {
            if inputText == "0" {
                inputText = num
            } else {
                inputText += num
            }
            isTypingNumber = true
        }
    }

    func addSymbol(_ symbol: String) {
        if let lastChar = inputText.last, "+-×÷".contains(lastChar) {
            return // prevent multiple operators
        }
        inputText += " \(symbol) "
        isTypingNumber = false
    }

    func clearAll() {
        inputText = "0"
        isTypingNumber = false
    }

    func toggleSign(){
        if let value = Double(inputText) {
            inputText = "\(value * -1)"
        }
    }

    func percentage(){
        if let value = Double(inputText) {
            inputText = "\(value / 100)"
        }
    }
//MARK: - calResult
    func calResult(){
        let components = inputText.split(separator: " ")

        if components.count == 3 {
            let firstValue = Double(components[0]) ?? 0
            let secondValue = Double(components[2]) ?? 0
            let operation = String(components[1])

            var result: Double = 0

            switch operation {
            case "+":
                result = firstValue + secondValue
            case "-":
                result = firstValue - secondValue
            case "×":
                result = firstValue * secondValue
            case "÷":
                result = secondValue != 0 ? firstValue / secondValue : 0
            default:
                break
            }

            inputText += " = \(result.clean)"
            isTypingNumber = false
        }
    }
}

// MARK: - Button Design
struct ButtonDesin: View {
    let title: String
    let isWide: Bool
    let action: () -> Void

    var body: some View {
        Button (action: action){
            Text(title)
                .font(.system(size: 40))
                .frame(width: zeroWidth, height: UIScreen.main.bounds.height * 0.10)
                .background(buttonStyle(button: title))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }

    var zeroWidth : CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return isWide ? screenWidth * 0.43 : screenWidth * 0.22
    }

    func buttonStyle(button: String) -> Color {
        switch button {
        case "AC", "+/-", "%": return .gray
        case "÷", "×", "-", "+", "=": return .orange
        default: return Color(.darkGray)
        }
    }
}

// MARK: - Double Extension
extension Double {
    var clean: String {
        self.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", self) : String(self)
    }
}

#Preview {
    Calculator()
}
