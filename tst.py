def find_matching_gems(board, match_length=3):
    rows = len(board)
    cols = len(board[0])

    # Check rows
    for row in range(rows):
        for col in range(cols - match_length + 1):
            if all(board[row][col + i] == board[row][col] for i in range(1, match_length)):
                matching_indices = [(row, col + i) for i in range(match_length)]
                return matching_indices  # Found a match

    # Check columns
    for col in range(cols):
        for row in range(rows - match_length + 1):
            if all(board[row + i][col] == board[row][col] for i in range(1, match_length)):
                matching_indices = [(row + i, col) for i in range(match_length)]
                return matching_indices  # Found a match

    return None  # No match found

# Example usage:
board = [
    ['A', 'B', 'A', 'C', 'A', 'A', 'A'],
    ['B', 'B', 'B', 'D', 'C', 'D', 'D'],
    ['A', 'C', 'A', 'A', 'A', 'C', 'C'],
    ['D', 'A', 'B', 'B', 'C', 'B', 'B'],
    ['C', 'C', 'A', 'D', 'D', 'A', 'A'],
]

matching_indices = find_matching_gems(board)

if matching_indices:
    print("Matching gems found at indices:", matching_indices)
else:
    print("No match found.")
