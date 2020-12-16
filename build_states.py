import csv

pairs = set()
evidence_lines = []


def ngram(n, string):
    size = len(string)
    for i in range(0, size - n + 1):
        yield string[i:i + n]


def process_name(name):
    prev_gram = "__start__"

    for gram in ngram(3, name):
        process_pair(prev_gram, gram)
        prev_gram = gram

    if prev_gram != '__start__':
        process_pair(prev_gram, '__end__')


def process_pair(start, end):
    global evidence_lines
    pairs.add((start, end))

    # evidence_lines.append(
    #     f"evidence(follows('{start}', '{end}')).\n"
    #     f"evidence(pairwise_true('{start}'), false).\n"
    #     f"---\n"
    # )

    # evidence_lines.append(
    #     f"evidence(follows_exclusive('{start}', '{end}')).\n"
    #     f"---\n"
    # )

    evidence_lines.append(
        f"evidence(follows('{start}', '{end}')).\n"
        f"---\n"
    )

def main():
    with open("data/american_surnames.txt") as names:
        for name in names:
            process_name(name.strip())

    with open("output/transitions.ev", "w") as ev:
        for line in sorted(evidence_lines):
            ev.write(line)

    with open("output/known_transitions.csv", "w") as states_file:
        writer = csv.writer(states_file, quotechar='"', quoting=csv.QUOTE_ALL)
        writer.writerow(["from_state", "to_state"])
        writer.writerows(sorted(pairs))

    with open("output/known_starting_states.csv", "w") as states_file:
        writer = csv.writer(states_file, quotechar='"', quoting=csv.QUOTE_ALL)
        writer.writerow(["state"])

        starting_states = {start for (start, end) in pairs}
        for state in sorted(starting_states):
            writer.writerow([state])


if __name__ == "__main__":
    main()
