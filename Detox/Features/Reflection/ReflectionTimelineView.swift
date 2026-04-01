import SwiftUI

struct ReflectionTimelineView: View {

    @State private var viewModel = ReflectionViewModel()
    @State private var headerVisible = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                header
                    .opacity(headerVisible ? 1 : 0)
                    .offset(y: headerVisible ? 0 : -12)

                DetoxDivider()
                    .padding(.top, Spacing.md)

                if viewModel.isEmpty {
                    emptyState
                } else {
                    reflectionList
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
            withAnimation(DetoxAnimation.slow.delay(0.1)) { headerVisible = true }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Reflections")
                    .font(DetoxFont.title)
                    .foregroundStyle(Color.black)

                Text("\(viewModel.totalCount) moments recorded")
                    .font(DetoxFont.micro)
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
            }

            Spacer()

            Button {
                viewModel.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .ultraLight))
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
                    .frame(width: 36, height: 36)
            }
        }
        .screenPadding()
        .padding(.top, Spacing.xl)
    }

    private var reflectionList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.groupedEntries, id: \.0) { (dateLabel, entries) in
                    Section {
                        ForEach(entries) { entry in
                            ReflectionRowView(entry: entry)
                                .fadeInOnAppear(delay: 0.05)
                            DetoxDivider()
                                .padding(.leading, Spacing.screenHorizontal)
                        }
                    } header: {
                        sectionHeader(dateLabel)
                    }
                }
            }
        }
    }

    private func sectionHeader(_ label: String) -> some View {
        Text(label)
            .font(DetoxFont.micro)
            .tracking(2)
            .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, Spacing.sm)
            .screenPadding()
            .background(Color.white)
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Spacer()
            Text("No reflections yet.")
                .font(DetoxFont.body)
                .foregroundStyle(Color.black)

            Text("They'll appear here each time you pause\nbefore opening an app.")
                .font(DetoxFont.caption)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .screenPadding()
        .fadeInOnAppear(delay: 0.3)
    }
}

private struct ReflectionRowView: View {

    let entry: ReflectionEntry

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {

            Text(entry.timestamp.reflectionTimeString)
                .font(DetoxFont.timestamp)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
                .frame(width: 56, alignment: .leading)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                contentView

                HStack(spacing: Spacing.xs) {
                    Text(entry.appDisplayName)
                        .font(DetoxFont.micro)
                        .foregroundStyle(Color.black.opacity(DetoxOpacity.ghost))

                    if entry.didContinue {
                        Text("· continued")
                            .font(DetoxFont.micro)
                            .foregroundStyle(Color.black.opacity(DetoxOpacity.ghost))
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, Spacing.md)
        .screenPadding()
    }

    @ViewBuilder
    private var contentView: some View {
        switch entry.responseType {
        case .typed:
            Text(entry.textContent ?? "")
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black)

        case .voice:
            HStack(spacing: Spacing.sm) {
                Image(systemName: "waveform")
                    .font(.system(size: 14, weight: .ultraLight))
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
                Text("Voice note")
                    .font(DetoxFont.bodyLight)
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
            }

        case .skipped:
            Text("Opened without reflecting.")
                .font(DetoxFont.bodyLight)
                .italic()
                .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
        }
    }
}
