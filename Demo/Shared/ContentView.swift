//
//  ContentView.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//



import RichTextKit
import SwiftUI

struct ContentView: View {

    @State
    private var text = NSAttributedString(string: "test")

    @StateObject
    private var context = RichTextContext()

    var body: some View {
        NavigationView {
            content.navigationTitle("RichTextKit")
        }
        .padding()
        .background(Color.gray.opacity(0.3))
    }
}

private extension ContentView {

    @ViewBuilder
    var content: some View {
        #if os(macOS)
        Text("MENU")
        #endif
        VStack {
            RichTextEditor(text: $text, context: context)
                .cornerRadius(5)
            Divider()
            styleButtons
            alignmentPicker
            colorPickers
            sizeTools
            actionButtons
        }.background(Color.gray.opacity(0.3))
    }
}

private extension ContentView {

    var actionButtons: some View {
        HStack {
            button(icon: .undo, action: context.undoLatestChange)
            button(icon: .redo, action: context.redoLatestChange)
            button(icon: .edit, action: context.toggleIsEditing)
                .highlighted(if: context.isEditingText)
        }
    }

    var alignmentPicker: some View {
        RichTextAlignmentPicker(
            title: "Alignment",
            selection: $context.alignment).pickerStyle(.segmented)
    }

    var colorPickers: some View {
        HStack {
            ColorPicker("background", selection: context.backgroundColorBinding)
            ColorPicker("foreground", selection: context.foregroundColorBinding)
        }
    }

    var sizeTools: some View {
        HStack {
            button(icon: Image(systemName: "minus")) {
                context.decrementFontSize()
            }
            FontSizePicker(selection: $context.fontSize)
            button(icon: Image(systemName: "plus")) {
                context.incrementFontSize()
            }
        }
    }

    var styleButtons: some View {
        HStack {
            button(for: .bold)
            button(for: .italic)
            button(for: .underlined)
        }
    }
}

private extension ContentView {

    func button(icon: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            icon
        }.buttonStyle(.bordered)
    }

    func button(for style: RichTextStyle) -> some View {
        button(icon: style.icon) {
            context.toggle(style)
        }.highlighted(if: context.hasStyle(style))
    }

    func button(for alignment: RichTextAlignment) -> some View {
        button(icon: alignment.icon) {
            context.alignment = alignment
        }.highlighted(if: context.alignment == alignment)
    }
}

private extension View {

    func highlighted(if condition: Bool) -> some View {
        foregroundColor(condition ? .accentColor : .primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
