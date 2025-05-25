
import SwiftUI

// MARK: - Bill Views
struct Bill10000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 248/255, green: 181/255, blue: 0.0))
                .frame(width: size * 2, height: size)
            Text("10000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

struct Bill5000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 196/255, green: 163/255, blue: 191/255))
                .frame(width: size * 2, height: size)
            Text("5000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

struct Bill1000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 128/255, green: 171/255, blue: 169/255))
                .frame(width: size * 2, height: size)
            Text("1000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

// MARK: - Coin Views
struct Coin500: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 255/255, green: 217/255, blue: 0/255))
                .frame(width: size, height: size)
            Text("500")
                .font(.system(size: size / 2 - 1, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

struct Coin100: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 192/255, green: 198/255, blue: 201/255))
                .frame(width: size, height: size)
            Text("100")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

struct Coin50: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 175/255, green: 175/255, blue: 176/255))
                .frame(width: size, height: size)
            Text("50")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

struct Coin10: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 184/255, green: 115/255, blue: 51/255))
                .frame(width: size, height: size)
            Text("10")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

struct Coin5: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 200/255, green: 153/255, blue: 50/255))
                .frame(width: size, height: size)
            Text("5")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

struct Coin1: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 230/255, green: 230/255, blue: 250/255))
                .frame(width: size, height: size)
            Text("1")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Helper Views
struct RemoveCashIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 44, height: 44)
            Image(systemName: "minus")
        }
    }
}
