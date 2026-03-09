// Platinum Sudoku
// #ID = 14912

// Puzzle Variables

// Puzzle Complete flags for Easy level Sudoku
SudokuEasyComplete      = (level) => bit0(0x15ABA4 + ((level-1)*0x40))
// Puzzle Complete flags for Medium level Sudoku
SudokuMediumComplete    = (level) => bit0(0x15C7C4 + ((level-1)*0x40))
// Puzzle Complete flags for Hard level Sudoku
SudokuHardComplete      = (level) => bit0(0x15E3E4 + ((level-1)*0x40))
// Puzzle Complete flags for Pro level Sudoku
SudokuProComplete       = (level) => bit0(0x160004 + ((level-1)*0x40))
// Puzzle Complete flags for Sudoku X level Sudoku
SudokuSudokuXComplete   = (level) => bit0(0x161C24 + ((level-1)*0x40))
// Puzzle Complete flags for Easy Kakuro
KakuroEasyComplete      = (level) => bit0(0x163844 + ((level-1)*0x40))
// Puzzle Complete flags for Medium Kakuro
KakuroMediumComplete    = (level) => bit0(0x165464 + ((level-1)*0x40))
// Puzzle Complete flags for Hard Kakuro
KakuroHardComplete      = (level) => bit0(0x167084 + ((level-1)*0x40))
// Current Challenge
//0x00 = Subtract
//0x01 = Pair Match
//0x02 = Shuffle
//0x03 = Choice Block
//0x04 = High Sum
//0x05 = Mine Detector
//Note: Starts at 0x00 by default. Doesn't cleanup after a challenge
CurrentChallenge        = dword(0x209530)
// Menu Selection
//0xffffffff = Main Menu
//0x01 = Sudoku
//0x02 = Kakuro
//0x03 = Challenges
//0x04 = Multiplayer
//0x05 = Options
MenuSelected            = dword(0x1e5c14)
Challenges              = { 0: "Subtract", 1: "Pair Match", 2: "Shuffle", 3: "Choice Block", 4: "High Sum", 5: "Mine Detector"}
Difficulty              = { 0: "Easy", 1: "Medium", 2: "Hard", 3: "Pro", 4: "Sudoku X"}
PuzzleID                = dword(0x158594) + 1
PuzzleDifficulty        = byte(0x158d80)
PuzzleActive            = dword(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) & 0xf2000000 == 0x02000000
PuzzleNotActive         = dword(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) & 0xf2000000 != 0x02000000
// Helper Functions
//
// [24-bit] Start of a linked list pointer
//+ 0x00 = Pointer
//++ 0x00 = Pointer
//+++ 0x06dc = Pointer to puzzle data
//++++ 0x0d58 = [32-bit] Current row selected (top row is 0)
//++++ 0x0d5c = [32-bit] Current column selected (leftmost column is 0)
//++++ 0x0d88 = [8-bit] Current puzzle size (used for both Sudoku and Kakuro) >> Not working?
//++++ 0x1068 = [8-bit] Column 1, Row 1 value currently shown (these continue for +0x2968. Goes down then moves right 1)
//++++ 0x1069 = [8-bit] Column 1, Row 1 correct value (these continue for +0x2968. Goes down then moves right 1)
//++++ 0xf7dc = [32-bit] Current Puzzles difficulty (0-4, 0 being Easy and 4 being Sudoku X)
//++++ 0xf96c = 9 of [32-bit] Number of X digit filled in (1 to 9)
//++++ 0xf9bc = [32-bit] [Boolean] Won a puzzle flag (flag isn't reset until a new puzzle is started)
//++++ 0xfa0c = [32-bit] Amount of hints remaining in current Sudoku or Kakuro game (set when you start a puzzle. Not reset once finished)
//++++ 0x010fcc = [32-bit] Current Sudoku lesson (0-5). Value is 0xffffffff when in normal puzzle or tutorial
//++++ 0x011304 = [32-bit] Challenge current number of puzzles solved
function CurrentPuzzleLevel()            => dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xf7dc)
function CompletedPuzzle()               => once(dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xf9bc) == 1) && never(dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xf9bc) == 0 && PuzzleActive)
function CompletedPuzzleSimplified()     => dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xf9bc) == 1 && PuzzleActive
function CompletedPuzzleSimplifiedPrev() => prev(dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xf9bc)) == 0
function HintsRemaining()                => dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0xfa0c)
function LessonLevelCheck(lessonNum)     => dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0x010fcc) == lessonNum
function CurrentChallengeRecord()        => dword(tbyte(tbyte(tbyte(tbyte(0x155d48))) + 0x06dc) + 0x011304)

function kakuroTrigger(rangeArray, difficulty)
{
    a = rangeArray
    cond = always_true()
    if difficulty == "Easy"
    {
        cond = (prev(KakuroEasyComplete(a[0])) + 
               prev(KakuroEasyComplete(a[1])) +
               prev(KakuroEasyComplete(a[2])) +
               prev(KakuroEasyComplete(a[3])) +
               prev(KakuroEasyComplete(a[4])) +
               prev(KakuroEasyComplete(a[5])) +
               prev(KakuroEasyComplete(a[6])) +
               prev(KakuroEasyComplete(a[7])) +
               prev(KakuroEasyComplete(a[8])) +
               prev(KakuroEasyComplete(a[9])) +
               prev(KakuroEasyComplete(a[10])) +
               prev(KakuroEasyComplete(a[11])) +
               prev(KakuroEasyComplete(a[12])) +
               prev(KakuroEasyComplete(a[13])) +
               prev(KakuroEasyComplete(a[14]))) == (length(a) - 1) && 
            measured(KakuroEasyComplete(a[0]) + 
                     KakuroEasyComplete(a[1]) +
                     KakuroEasyComplete(a[2]) +
                     KakuroEasyComplete(a[3]) +
                     KakuroEasyComplete(a[4]) +
                     KakuroEasyComplete(a[5]) +
                     KakuroEasyComplete(a[6]) +
                     KakuroEasyComplete(a[7]) +
                     KakuroEasyComplete(a[8]) +
                     KakuroEasyComplete(a[9]) +
                     KakuroEasyComplete(a[10]) +
                     KakuroEasyComplete(a[11]) +
                     KakuroEasyComplete(a[12]) +
                     KakuroEasyComplete(a[13]) +
                     KakuroEasyComplete(a[14]) == (length(a)))
    }
    else if difficulty == "Medium"
    {
        cond = (prev(KakuroMediumComplete(a[0])) + 
               prev(KakuroMediumComplete(a[1])) +
               prev(KakuroMediumComplete(a[2])) +
               prev(KakuroMediumComplete(a[3])) +
               prev(KakuroMediumComplete(a[4])) +
               prev(KakuroMediumComplete(a[5])) +
               prev(KakuroMediumComplete(a[6])) +
               prev(KakuroMediumComplete(a[7])) +
               prev(KakuroMediumComplete(a[8])) +
               prev(KakuroMediumComplete(a[9])) +
               prev(KakuroMediumComplete(a[10])) +
               prev(KakuroMediumComplete(a[11])) +
               prev(KakuroMediumComplete(a[12])) +
               prev(KakuroMediumComplete(a[13])) +
               prev(KakuroMediumComplete(a[14]))) == (length(a) - 1) && 
             measured(KakuroMediumComplete(a[0]) + 
                     KakuroMediumComplete(a[1]) +
                     KakuroMediumComplete(a[2]) +
                     KakuroMediumComplete(a[3]) +
                     KakuroMediumComplete(a[4]) +
                     KakuroMediumComplete(a[5]) +
                     KakuroMediumComplete(a[6]) +
                     KakuroMediumComplete(a[7]) +
                     KakuroMediumComplete(a[8]) +
                     KakuroMediumComplete(a[9]) +
                     KakuroMediumComplete(a[10]) +
                     KakuroMediumComplete(a[11]) +
                     KakuroMediumComplete(a[12]) +
                     KakuroMediumComplete(a[13]) +
                     KakuroMediumComplete(a[14]) == (length(a)))
    }
    else
    {
        cond = (prev(KakuroHardComplete(a[0])) + 
               prev(KakuroHardComplete(a[1])) +
               prev(KakuroHardComplete(a[2])) +
               prev(KakuroHardComplete(a[3])) +
               prev(KakuroHardComplete(a[4])) +
               prev(KakuroHardComplete(a[5])) +
               prev(KakuroHardComplete(a[6])) +
               prev(KakuroHardComplete(a[7])) +
               prev(KakuroHardComplete(a[8])) +
               prev(KakuroHardComplete(a[9])) +
               prev(KakuroHardComplete(a[10])) +
               prev(KakuroHardComplete(a[11])) +
               prev(KakuroHardComplete(a[12])) +
               prev(KakuroHardComplete(a[13])) +
               prev(KakuroHardComplete(a[14]))) == (length(a) - 1) && 
            measured(KakuroHardComplete(a[0]) + 
                     KakuroHardComplete(a[1]) +
                     KakuroHardComplete(a[2]) +
                     KakuroHardComplete(a[3]) +
                     KakuroHardComplete(a[4]) +
                     KakuroHardComplete(a[5]) +
                     KakuroHardComplete(a[6]) +
                     KakuroHardComplete(a[7]) +
                     KakuroHardComplete(a[8]) +
                     KakuroHardComplete(a[9]) +
                     KakuroHardComplete(a[10]) +
                     KakuroHardComplete(a[11]) +
                     KakuroHardComplete(a[12]) +
                     KakuroHardComplete(a[13]) +
                     KakuroHardComplete(a[14]) == (length(a)))
    }
    return cond
}

// Rich Presence
//
rich_presence_conditional_display(MenuSelected == 0xffffffff, "Main Menu")
rich_presence_conditional_display(MenuSelected == 0x01 && PuzzleNotActive, "Browsing Sudoku Puzzles")
rich_presence_conditional_display(MenuSelected == 0x01 && PuzzleActive, "Solving Sudoku Puzzle {0} on {1}", rich_presence_value("Digit", PuzzleID), rich_presence_lookup("Difficulty", PuzzleDifficulty, Difficulty))
rich_presence_conditional_display(MenuSelected == 0x02 && PuzzleNotActive, "Browsing Kakuro Puzzles")
rich_presence_conditional_display(MenuSelected == 0x02 && PuzzleActive, "Solving Kakuro Puzzle {0} on {1}", rich_presence_value("Digit", PuzzleID), rich_presence_lookup("Difficulty", PuzzleDifficulty, Difficulty))
rich_presence_conditional_display(MenuSelected == 0x03, "Attempting Sudoku Challenge: {0}", rich_presence_lookup("Challenges", CurrentChallenge, Challenges))
rich_presence_conditional_display(MenuSelected == 0x04, "Playing Multiplayer")
rich_presence_conditional_display(MenuSelected == 0x05, "Browsing Options")
rich_presence_display("Playing Platinum Sudoku")


// Achievements
//
// Easy Sudokus
a = range(1,2)
achievement(
    id = 572218,
    badge = "649992",
    title = "Cherry Blossoms",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1])) == (length(a))
)
a = range(4,5)
achievement (
    id = 576046,
    badge = "653839",
    title = "Simple Arithmetic",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1])) == (length(a))
)
a = range(7,9)
achievement (
    id = 576049,
    badge = "653841",
    title = "Classically Trained",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]))== (length(a))
)
a = range(11,16)
achievement (
    id = 576050,
    badge = "653842",
    title = "Land of the Rising Sun",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4])) +
               prev(SudokuEasyComplete(a[5]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4]) +
                     SudokuEasyComplete(a[5])) == (length(a))
)
a = range(18,29)
achievement (
    id = 576051,
    badge = "653843",
    title = "Three's a Crowd",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4])) +
               prev(SudokuEasyComplete(a[5])) +
               prev(SudokuEasyComplete(a[6])) +
               prev(SudokuEasyComplete(a[7])) +
               prev(SudokuEasyComplete(a[8])) +
               prev(SudokuEasyComplete(a[9])) +
               prev(SudokuEasyComplete(a[10])) +
               prev(SudokuEasyComplete(a[11]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4]) +
                     SudokuEasyComplete(a[5]) +
                     SudokuEasyComplete(a[6]) +
                     SudokuEasyComplete(a[7]) +
                     SudokuEasyComplete(a[8]) +
                     SudokuEasyComplete(a[9]) +
                     SudokuEasyComplete(a[10]) +
                     SudokuEasyComplete(a[11])) == (length(a))
)
a = range(31,44)
achievement (
    id = 576052,
    badge = "653844",
    title = "Freehanding",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4])) +
               prev(SudokuEasyComplete(a[5])) +
               prev(SudokuEasyComplete(a[6])) +
               prev(SudokuEasyComplete(a[7])) +
               prev(SudokuEasyComplete(a[8])) +
               prev(SudokuEasyComplete(a[9])) +
               prev(SudokuEasyComplete(a[10])) +
               prev(SudokuEasyComplete(a[11])) +
               prev(SudokuEasyComplete(a[12])) +
               prev(SudokuEasyComplete(a[13]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4]) +
                     SudokuEasyComplete(a[5]) +
                     SudokuEasyComplete(a[6]) +
                     SudokuEasyComplete(a[7]) +
                     SudokuEasyComplete(a[8]) +
                     SudokuEasyComplete(a[9]) +
                     SudokuEasyComplete(a[10]) +
                     SudokuEasyComplete(a[11]) +
                     SudokuEasyComplete(a[12]) +
                     SudokuEasyComplete(a[13])) == (length(a))
)
a = range(46,50)
achievement (
    id = 576053,
    badge = "653845",
    title = "Everyday I'm Shuffling",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4])) == (length(a))
)
a = range(52,87)
achievement (
    id = 576054,
    badge = "653846",
    title = "Don't Point, It's Rude",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4])) +
               prev(SudokuEasyComplete(a[5])) +
               prev(SudokuEasyComplete(a[6])) +
               prev(SudokuEasyComplete(a[7])) +
               prev(SudokuEasyComplete(a[8])) +
               prev(SudokuEasyComplete(a[9])) +
               prev(SudokuEasyComplete(a[10])) +
               prev(SudokuEasyComplete(a[11])) +
               prev(SudokuEasyComplete(a[12])) +
               prev(SudokuEasyComplete(a[13])) +
               prev(SudokuEasyComplete(a[14])) +
               prev(SudokuEasyComplete(a[15])) +
               prev(SudokuEasyComplete(a[16])) +
               prev(SudokuEasyComplete(a[17])) +
               prev(SudokuEasyComplete(a[18])) +
               prev(SudokuEasyComplete(a[19])) +
               prev(SudokuEasyComplete(a[20])) +
               prev(SudokuEasyComplete(a[21])) +
               prev(SudokuEasyComplete(a[22])) +
               prev(SudokuEasyComplete(a[23])) +
               prev(SudokuEasyComplete(a[24])) +
               prev(SudokuEasyComplete(a[25])) +
               prev(SudokuEasyComplete(a[26])) +
               prev(SudokuEasyComplete(a[27])) +
               prev(SudokuEasyComplete(a[28])) +
               prev(SudokuEasyComplete(a[29])) +
               prev(SudokuEasyComplete(a[30])) +
               prev(SudokuEasyComplete(a[31])) +
               prev(SudokuEasyComplete(a[32])) +
               prev(SudokuEasyComplete(a[33])) +
               prev(SudokuEasyComplete(a[34])) +
               prev(SudokuEasyComplete(a[35]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4]) +
                     SudokuEasyComplete(a[5]) +
                     SudokuEasyComplete(a[6]) +
                     SudokuEasyComplete(a[7]) +
                     SudokuEasyComplete(a[8]) +
                     SudokuEasyComplete(a[9]) +
                     SudokuEasyComplete(a[10]) +
                     SudokuEasyComplete(a[11]) +
                     SudokuEasyComplete(a[12]) +
                     SudokuEasyComplete(a[13]) +
                     SudokuEasyComplete(a[14]) +
                     SudokuEasyComplete(a[15]) +
                     SudokuEasyComplete(a[16]) +
                     SudokuEasyComplete(a[17]) +
                     SudokuEasyComplete(a[18]) +
                     SudokuEasyComplete(a[19]) +
                     SudokuEasyComplete(a[20]) +
                     SudokuEasyComplete(a[21]) +
                     SudokuEasyComplete(a[22]) +
                     SudokuEasyComplete(a[23]) +
                     SudokuEasyComplete(a[24]) +
                     SudokuEasyComplete(a[25]) +
                     SudokuEasyComplete(a[26]) +
                     SudokuEasyComplete(a[27]) +
                     SudokuEasyComplete(a[28]) +
                     SudokuEasyComplete(a[29]) +
                     SudokuEasyComplete(a[30]) +
                     SudokuEasyComplete(a[31]) +
                     SudokuEasyComplete(a[32]) +
                     SudokuEasyComplete(a[33]) +
                     SudokuEasyComplete(a[34]) +
                     SudokuEasyComplete(a[35])) == (length(a))
)
a = range(89,104)
achievement (
    id = 576055,
    badge = "653847",
    title = "That Was Easy",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Easy",
    points = 1,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuEasyComplete(a[0])) + 
               prev(SudokuEasyComplete(a[1])) +
               prev(SudokuEasyComplete(a[2])) +
               prev(SudokuEasyComplete(a[3])) +
               prev(SudokuEasyComplete(a[4])) +
               prev(SudokuEasyComplete(a[5])) +
               prev(SudokuEasyComplete(a[6])) +
               prev(SudokuEasyComplete(a[7])) +
               prev(SudokuEasyComplete(a[8])) +
               prev(SudokuEasyComplete(a[9])) +
               prev(SudokuEasyComplete(a[10])) +
               prev(SudokuEasyComplete(a[11])) +
               prev(SudokuEasyComplete(a[12])) +
               prev(SudokuEasyComplete(a[13])) +
               prev(SudokuEasyComplete(a[14])) +
               prev(SudokuEasyComplete(a[15]))) == (length(a) - 1) && 
                    (SudokuEasyComplete(a[0]) + 
                     SudokuEasyComplete(a[1]) +
                     SudokuEasyComplete(a[2]) +
                     SudokuEasyComplete(a[3]) +
                     SudokuEasyComplete(a[4]) +
                     SudokuEasyComplete(a[5]) +
                     SudokuEasyComplete(a[6]) +
                     SudokuEasyComplete(a[7]) +
                     SudokuEasyComplete(a[8]) +
                     SudokuEasyComplete(a[9]) +
                     SudokuEasyComplete(a[10]) +
                     SudokuEasyComplete(a[11]) +
                     SudokuEasyComplete(a[12]) +
                     SudokuEasyComplete(a[13]) +
                     SudokuEasyComplete(a[14]) +
                     SudokuEasyComplete(a[15])) == (length(a))
)

// Medium Sudokus
a = range(1,3)
achievement (
    id = 584015,
    badge = "662460",
    title = "City of Owl's",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2])) == (length(a)))
    
a = range(5,7)
achievement (
    id = 584016,
    badge = "662461",
    title = "Illuminate",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2])) == (length(a)))
    
a = range(9,14)
achievement (
    id = 584017,
    badge = "662462",
    title = "Just One More Square",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2]) +
                    SudokuMediumComplete(a[3]) +
                    SudokuMediumComplete(a[4]) +
                    SudokuMediumComplete(a[5])) == (length(a)))
    
a = range(16,18)
achievement (
    id = 584018,
    badge = "662463",
    title = "Things Are a Little Hazy",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2])) == (length(a)))
    
a = range(20,28)
achievement (
    id = 584019,
    badge = "662464",
    title = "Aim for the Top",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5])) +
               prev(SudokuMediumComplete(a[6])) +
               prev(SudokuMediumComplete(a[7])) +
               prev(SudokuMediumComplete(a[8]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2]) +
                    SudokuMediumComplete(a[3]) +
                    SudokuMediumComplete(a[4]) +
                    SudokuMediumComplete(a[5]) +
                    SudokuMediumComplete(a[6]) +
                    SudokuMediumComplete(a[7]) +
                    SudokuMediumComplete(a[8])) == (length(a)))
    
a = range(30,36)
achievement (
    id = 584020,
    badge = "662465",
    title = "Rated R",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) +
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5])) +
               prev(SudokuMediumComplete(a[6]))) == (length(a) - 1) &&
                    (SudokuMediumComplete(a[0]) +
                    SudokuMediumComplete(a[1]) +
                    SudokuMediumComplete(a[2]) +
                    SudokuMediumComplete(a[3]) +
                    SudokuMediumComplete(a[4]) +
                    SudokuMediumComplete(a[5]) +
                    SudokuMediumComplete(a[6])) == (length(a)))

a = range(38,52)
achievement (
    id = 584021,
    badge = "662466",
    title = "The New Orleans Scene",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) + 
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5])) +
               prev(SudokuMediumComplete(a[6])) +
               prev(SudokuMediumComplete(a[7])) +
               prev(SudokuMediumComplete(a[8])) +
               prev(SudokuMediumComplete(a[9])) +
               prev(SudokuMediumComplete(a[10])) +
               prev(SudokuMediumComplete(a[11])) +
               prev(SudokuMediumComplete(a[12])) +
               prev(SudokuMediumComplete(a[13])) +
               prev(SudokuMediumComplete(a[14]))) == (length(a) - 1) && 
                    (SudokuMediumComplete(a[0]) + 
                     SudokuMediumComplete(a[1]) +
                     SudokuMediumComplete(a[2]) +
                     SudokuMediumComplete(a[3]) +
                     SudokuMediumComplete(a[4]) +
                     SudokuMediumComplete(a[5]) +
                     SudokuMediumComplete(a[6]) +
                     SudokuMediumComplete(a[7]) +
                     SudokuMediumComplete(a[8]) +
                     SudokuMediumComplete(a[9]) +
                     SudokuMediumComplete(a[10]) +
                     SudokuMediumComplete(a[11]) +
                     SudokuMediumComplete(a[12]) +
                     SudokuMediumComplete(a[13]) +
                     SudokuMediumComplete(a[14])) == (length(a)))

a = range(54,63)
achievement (
    id = 584022,
    badge = "662467",
    title = "X Marks the Spot",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) + 
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5])) +
               prev(SudokuMediumComplete(a[6])) +
               prev(SudokuMediumComplete(a[7])) +
               prev(SudokuMediumComplete(a[8])) +
               prev(SudokuMediumComplete(a[9]))) == (length(a) - 1) && 
                    (SudokuMediumComplete(a[0]) + 
                     SudokuMediumComplete(a[1]) +
                     SudokuMediumComplete(a[2]) +
                     SudokuMediumComplete(a[3]) +
                     SudokuMediumComplete(a[4]) +
                     SudokuMediumComplete(a[5]) +
                     SudokuMediumComplete(a[6]) +
                     SudokuMediumComplete(a[7]) +
                     SudokuMediumComplete(a[8]) +
                     SudokuMediumComplete(a[9])) == (length(a)))
    
a = range(65,104)
achievement (
    id = 584023,
    badge = "662468",
    title = "Medium-Rare Please",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Medium",
    points = 2,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuMediumComplete(a[0])) + 
               prev(SudokuMediumComplete(a[1])) +
               prev(SudokuMediumComplete(a[2])) +
               prev(SudokuMediumComplete(a[3])) +
               prev(SudokuMediumComplete(a[4])) +
               prev(SudokuMediumComplete(a[5])) +
               prev(SudokuMediumComplete(a[6])) +
               prev(SudokuMediumComplete(a[7])) +
               prev(SudokuMediumComplete(a[8])) +
               prev(SudokuMediumComplete(a[9])) +
               prev(SudokuMediumComplete(a[10])) +
               prev(SudokuMediumComplete(a[11])) +
               prev(SudokuMediumComplete(a[12])) +
               prev(SudokuMediumComplete(a[13])) +
               prev(SudokuMediumComplete(a[14])) +
               prev(SudokuMediumComplete(a[15])) +
               prev(SudokuMediumComplete(a[16])) +
               prev(SudokuMediumComplete(a[17])) +
               prev(SudokuMediumComplete(a[18])) +
               prev(SudokuMediumComplete(a[19])) +
               prev(SudokuMediumComplete(a[20])) +
               prev(SudokuMediumComplete(a[21])) +
               prev(SudokuMediumComplete(a[22])) +
               prev(SudokuMediumComplete(a[23])) +
               prev(SudokuMediumComplete(a[24])) +
               prev(SudokuMediumComplete(a[25])) +
               prev(SudokuMediumComplete(a[26])) +
               prev(SudokuMediumComplete(a[27])) +
               prev(SudokuMediumComplete(a[28])) +
               prev(SudokuMediumComplete(a[29])) +
               prev(SudokuMediumComplete(a[30])) +
               prev(SudokuMediumComplete(a[31])) +
               prev(SudokuMediumComplete(a[32])) +
               prev(SudokuMediumComplete(a[33])) +
               prev(SudokuMediumComplete(a[34])) +
               prev(SudokuMediumComplete(a[35])) +
               prev(SudokuMediumComplete(a[36])) +
               prev(SudokuMediumComplete(a[37])) +
               prev(SudokuMediumComplete(a[38])) +
               prev(SudokuMediumComplete(a[39]))) == (length(a) - 1) && 
                    (SudokuMediumComplete(a[0]) + 
                     SudokuMediumComplete(a[1]) +
                     SudokuMediumComplete(a[2]) +
                     SudokuMediumComplete(a[3]) +
                     SudokuMediumComplete(a[4]) +
                     SudokuMediumComplete(a[5]) +
                     SudokuMediumComplete(a[6]) +
                     SudokuMediumComplete(a[7]) +
                     SudokuMediumComplete(a[8]) +
                     SudokuMediumComplete(a[9]) +
                     SudokuMediumComplete(a[10]) +
                     SudokuMediumComplete(a[11]) +
                     SudokuMediumComplete(a[12]) +
                     SudokuMediumComplete(a[13]) +
                     SudokuMediumComplete(a[14]) +
                     SudokuMediumComplete(a[15]) +
                     SudokuMediumComplete(a[16]) +
                     SudokuMediumComplete(a[17]) +
                     SudokuMediumComplete(a[18]) +
                     SudokuMediumComplete(a[19]) +
                     SudokuMediumComplete(a[20]) +
                     SudokuMediumComplete(a[21]) +
                     SudokuMediumComplete(a[22]) +
                     SudokuMediumComplete(a[23]) +
                     SudokuMediumComplete(a[24]) +
                     SudokuMediumComplete(a[25]) +
                     SudokuMediumComplete(a[26]) +
                     SudokuMediumComplete(a[27]) +
                     SudokuMediumComplete(a[28]) +
                     SudokuMediumComplete(a[29]) +
                     SudokuMediumComplete(a[30]) +
                     SudokuMediumComplete(a[31]) +
                     SudokuMediumComplete(a[32]) +
                     SudokuMediumComplete(a[33]) +
                     SudokuMediumComplete(a[34]) +
                     SudokuMediumComplete(a[35]) +
                     SudokuMediumComplete(a[36]) +
                     SudokuMediumComplete(a[37]) +
                     SudokuMediumComplete(a[38]) +
                     SudokuMediumComplete(a[39])) == (length(a)))

// Hard Sudokus
a = range(1,4)
achievement (
    id = 586683,
    badge = "665186",
    title = "Mine Sweeper Anyone?",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3])) == (length(a)))

a = range(6,10)
achievement (
    id = 586686,
    badge = "665189",
    title = "Old School Terminal",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4])) == (length(a)))

a = range(12,28)
achievement (
    id = 586684,
    badge = "665187",
    title = "Starting to Look Like Algebra",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8])) +
               prev(SudokuHardComplete(a[9])) +
               prev(SudokuHardComplete(a[10])) +
               prev(SudokuHardComplete(a[11])) +
               prev(SudokuHardComplete(a[12])) +
               prev(SudokuHardComplete(a[13])) +
               prev(SudokuHardComplete(a[14])) +
               prev(SudokuHardComplete(a[15])) +
               prev(SudokuHardComplete(a[16]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8]) +
                    SudokuHardComplete(a[9]) +
                    SudokuHardComplete(a[10]) +
                    SudokuHardComplete(a[11]) +
                    SudokuHardComplete(a[12]) +
                    SudokuHardComplete(a[13]) +
                    SudokuHardComplete(a[14]) +
                    SudokuHardComplete(a[15]) +
                    SudokuHardComplete(a[16])) == (length(a)))

a = range(30,43)
achievement (
    id = 586685,
    badge = "665188",
    title = "Uneven Squares",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8])) +
               prev(SudokuHardComplete(a[9])) +
               prev(SudokuHardComplete(a[10])) +
               prev(SudokuHardComplete(a[11])) +
               prev(SudokuHardComplete(a[12])) +
               prev(SudokuHardComplete(a[13]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8]) +
                    SudokuHardComplete(a[9]) +
                    SudokuHardComplete(a[10]) +
                    SudokuHardComplete(a[11]) +
                    SudokuHardComplete(a[12]) +
                    SudokuHardComplete(a[13])) == (length(a)))

a = range(45,53)
achievement (
    id = 586687,
    badge = "665190",
    title = "Get Your Inked Ribbon Ready",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8])) == (length(a)))

a = range(55,70)
achievement (
    id = 586688,
    badge = "665191",
    title = "Expelled",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8])) +
               prev(SudokuHardComplete(a[9])) +
               prev(SudokuHardComplete(a[10])) +
               prev(SudokuHardComplete(a[11])) +
               prev(SudokuHardComplete(a[12])) +
               prev(SudokuHardComplete(a[13])) +
               prev(SudokuHardComplete(a[14])) +
               prev(SudokuHardComplete(a[15]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8]) +
                    SudokuHardComplete(a[9]) +
                    SudokuHardComplete(a[10]) +
                    SudokuHardComplete(a[11]) +
                    SudokuHardComplete(a[12]) +
                    SudokuHardComplete(a[13]) +
                    SudokuHardComplete(a[14]) +
                    SudokuHardComplete(a[15])) == (length(a)))

a = range(72,82)
achievement (
    id = 586689,
    badge = "665192",
    title = "Something to Do with Flowers",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8])) +
               prev(SudokuHardComplete(a[9])) +
               prev(SudokuHardComplete(a[10]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8]) +
                    SudokuHardComplete(a[9]) +
                    SudokuHardComplete(a[10])) == (length(a)))

a = range(84,104)
achievement (
    id = 586690,
    badge = "665193",
    title = "Hard Boiled",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Hard",
    points = 3,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuHardComplete(a[0])) +
               prev(SudokuHardComplete(a[1])) +
               prev(SudokuHardComplete(a[2])) +
               prev(SudokuHardComplete(a[3])) +
               prev(SudokuHardComplete(a[4])) +
               prev(SudokuHardComplete(a[5])) +
               prev(SudokuHardComplete(a[6])) +
               prev(SudokuHardComplete(a[7])) +
               prev(SudokuHardComplete(a[8])) +
               prev(SudokuHardComplete(a[9])) +
               prev(SudokuHardComplete(a[10])) +
               prev(SudokuHardComplete(a[11])) +
               prev(SudokuHardComplete(a[12])) +
               prev(SudokuHardComplete(a[13])) +
               prev(SudokuHardComplete(a[14])) +
               prev(SudokuHardComplete(a[15])) +
               prev(SudokuHardComplete(a[16])) +
               prev(SudokuHardComplete(a[17])) +
               prev(SudokuHardComplete(a[18])) +
               prev(SudokuHardComplete(a[19])) +
               prev(SudokuHardComplete(a[20]))) == (length(a) - 1) &&
                    (SudokuHardComplete(a[0]) +
                    SudokuHardComplete(a[1]) +
                    SudokuHardComplete(a[2]) +
                    SudokuHardComplete(a[3]) +
                    SudokuHardComplete(a[4]) +
                    SudokuHardComplete(a[5]) +
                    SudokuHardComplete(a[6]) +
                    SudokuHardComplete(a[7]) +
                    SudokuHardComplete(a[8]) +
                    SudokuHardComplete(a[9]) +
                    SudokuHardComplete(a[10]) +
                    SudokuHardComplete(a[11]) +
                    SudokuHardComplete(a[12]) +
                    SudokuHardComplete(a[13]) +
                    SudokuHardComplete(a[14]) +
                    SudokuHardComplete(a[15]) +
                    SudokuHardComplete(a[16]) +
                    SudokuHardComplete(a[17]) +
                    SudokuHardComplete(a[18]) +
                    SudokuHardComplete(a[19]) +
                    SudokuHardComplete(a[20])) == (length(a)))

// Pro Sudokus
a = range(1,5)
achievement (
    id = 586691,
    badge = "665194",
    title = "Empire State",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4])) == (length(a)))

a = range(7,13)
achievement (
    id = 586692,
    badge = "665195",
    title = "Flow State",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6])) == (length(a)))

a = range(15,22)
achievement (
    id = 586693,
    badge = "665196",
    title = "This Just in!",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7])) == (length(a)))

a = range(24,36)
achievement (
    id = 586694,
    badge = "665197",
    title = "An Indoor Day",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7])) +
               prev(SudokuProComplete(a[8])) +
               prev(SudokuProComplete(a[9])) +
               prev(SudokuProComplete(a[10])) +
               prev(SudokuProComplete(a[11])) +
               prev(SudokuProComplete(a[12]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7]) +
                    SudokuProComplete(a[8]) +
                    SudokuProComplete(a[9]) +
                    SudokuProComplete(a[10]) +
                    SudokuProComplete(a[11]) +
                    SudokuProComplete(a[12])) == (length(a)))

a = range(38,54)
achievement (
    id = 586695,
    badge = "665198",
    title = "Silent but Deadly",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7])) +
               prev(SudokuProComplete(a[8])) +
               prev(SudokuProComplete(a[9])) +
               prev(SudokuProComplete(a[10])) +
               prev(SudokuProComplete(a[11])) +
               prev(SudokuProComplete(a[12])) +
               prev(SudokuProComplete(a[13])) +
               prev(SudokuProComplete(a[14])) +
               prev(SudokuProComplete(a[15])) +
               prev(SudokuProComplete(a[16]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7]) +
                    SudokuProComplete(a[8]) +
                    SudokuProComplete(a[9]) +
                    SudokuProComplete(a[10]) +
                    SudokuProComplete(a[11]) +
                    SudokuProComplete(a[12]) +
                    SudokuProComplete(a[13]) +
                    SudokuProComplete(a[14]) +
                    SudokuProComplete(a[15]) +
                    SudokuProComplete(a[16])) == (length(a)))

a = range(56,63)
achievement (
    id = 586696,
    badge = "665199",
    title = "Part of the Tribe",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7])) == (length(a)))

a = range(65,86)
achievement (
    id = 586697,
    badge = "665200",
    title = "Blackletter",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7])) +
               prev(SudokuProComplete(a[8])) +
               prev(SudokuProComplete(a[9])) +
               prev(SudokuProComplete(a[10])) +
               prev(SudokuProComplete(a[11])) +
               prev(SudokuProComplete(a[12])) +
               prev(SudokuProComplete(a[13])) +
               prev(SudokuProComplete(a[14])) +
               prev(SudokuProComplete(a[15])) +
               prev(SudokuProComplete(a[16])) +
               prev(SudokuProComplete(a[17])) +
               prev(SudokuProComplete(a[18])) +
               prev(SudokuProComplete(a[19])) +
               prev(SudokuProComplete(a[20])) +
               prev(SudokuProComplete(a[21]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7]) +
                    SudokuProComplete(a[8]) +
                    SudokuProComplete(a[9]) +
                    SudokuProComplete(a[10]) +
                    SudokuProComplete(a[11]) +
                    SudokuProComplete(a[12]) +
                    SudokuProComplete(a[13]) +
                    SudokuProComplete(a[14]) +
                    SudokuProComplete(a[15]) +
                    SudokuProComplete(a[16]) +
                    SudokuProComplete(a[17]) +
                    SudokuProComplete(a[18]) +
                    SudokuProComplete(a[19]) +
                    SudokuProComplete(a[20]) +
                    SudokuProComplete(a[21])) == (length(a)))

a = range(88,104)
achievement (
    id = 586698,
    badge = "665201",
    title = "Professional Courtesy",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Pro",
    points = 4,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuProComplete(a[0])) +
               prev(SudokuProComplete(a[1])) +
               prev(SudokuProComplete(a[2])) +
               prev(SudokuProComplete(a[3])) +
               prev(SudokuProComplete(a[4])) +
               prev(SudokuProComplete(a[5])) +
               prev(SudokuProComplete(a[6])) +
               prev(SudokuProComplete(a[7])) +
               prev(SudokuProComplete(a[8])) +
               prev(SudokuProComplete(a[9])) +
               prev(SudokuProComplete(a[10])) +
               prev(SudokuProComplete(a[11])) +
               prev(SudokuProComplete(a[12])) +
               prev(SudokuProComplete(a[13])) +
               prev(SudokuProComplete(a[14])) +
               prev(SudokuProComplete(a[15])) +
               prev(SudokuProComplete(a[16]))) == (length(a) - 1) &&
                    (SudokuProComplete(a[0]) +
                    SudokuProComplete(a[1]) +
                    SudokuProComplete(a[2]) +
                    SudokuProComplete(a[3]) +
                    SudokuProComplete(a[4]) +
                    SudokuProComplete(a[5]) +
                    SudokuProComplete(a[6]) +
                    SudokuProComplete(a[7]) +
                    SudokuProComplete(a[8]) +
                    SudokuProComplete(a[9]) +
                    SudokuProComplete(a[10]) +
                    SudokuProComplete(a[11]) +
                    SudokuProComplete(a[12]) +
                    SudokuProComplete(a[13]) +
                    SudokuProComplete(a[14]) +
                    SudokuProComplete(a[15]) +
                    SudokuProComplete(a[16])) == (length(a)))

// Sudoku X Sudokus
a = range(1,6)
achievement (
    id = 586699,
    badge = "665202",
    title = "Think Really Large",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5])) == (length(a)))

a = range(8,14)
achievement (
    id = 586700,
    badge = "665203",
    title = "Fire and Brimstone",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5])) +
               prev(SudokuSudokuXComplete(a[6]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5]) +
                    SudokuSudokuXComplete(a[6])) == (length(a)))

a = range(16,17)
achievement (
    id = 586701,
    badge = "665204",
    title = "If You're Feeling Fancy",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1])) == (length(a)))

a = range(19,43)
achievement (
    id = 586702,
    badge = "665205",
    title = "Soapy Water",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5])) +
               prev(SudokuSudokuXComplete(a[6])) +
               prev(SudokuSudokuXComplete(a[7])) +
               prev(SudokuSudokuXComplete(a[8])) +
               prev(SudokuSudokuXComplete(a[9])) +
               prev(SudokuSudokuXComplete(a[10])) +
               prev(SudokuSudokuXComplete(a[11])) +
               prev(SudokuSudokuXComplete(a[12])) +
               prev(SudokuSudokuXComplete(a[13])) +
               prev(SudokuSudokuXComplete(a[14])) +
               prev(SudokuSudokuXComplete(a[15])) +
               prev(SudokuSudokuXComplete(a[16])) +
               prev(SudokuSudokuXComplete(a[17])) +
               prev(SudokuSudokuXComplete(a[18])) +
               prev(SudokuSudokuXComplete(a[19])) +
               prev(SudokuSudokuXComplete(a[20])) +
               prev(SudokuSudokuXComplete(a[21])) +
               prev(SudokuSudokuXComplete(a[22])) +
               prev(SudokuSudokuXComplete(a[23])) +
               prev(SudokuSudokuXComplete(a[24]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5]) +
                    SudokuSudokuXComplete(a[6]) +
                    SudokuSudokuXComplete(a[7]) +
                    SudokuSudokuXComplete(a[8]) +
                    SudokuSudokuXComplete(a[9]) +
                    SudokuSudokuXComplete(a[10]) +
                    SudokuSudokuXComplete(a[11]) +
                    SudokuSudokuXComplete(a[12]) +
                    SudokuSudokuXComplete(a[13]) +
                    SudokuSudokuXComplete(a[14]) +
                    SudokuSudokuXComplete(a[15]) +
                    SudokuSudokuXComplete(a[16]) +
                    SudokuSudokuXComplete(a[17]) +
                    SudokuSudokuXComplete(a[18]) +
                    SudokuSudokuXComplete(a[19]) +
                    SudokuSudokuXComplete(a[20]) +
                    SudokuSudokuXComplete(a[21]) +
                    SudokuSudokuXComplete(a[22]) +
                    SudokuSudokuXComplete(a[23]) +
                    SudokuSudokuXComplete(a[24])) == (length(a)))

a = range(45,55)
achievement (
    id = 586703,
    badge = "665206",
    title = "Sharp Corners",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5])) +
               prev(SudokuSudokuXComplete(a[6])) +
               prev(SudokuSudokuXComplete(a[7])) +
               prev(SudokuSudokuXComplete(a[8])) +
               prev(SudokuSudokuXComplete(a[9])) +
               prev(SudokuSudokuXComplete(a[10]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5]) +
                    SudokuSudokuXComplete(a[6]) +
                    SudokuSudokuXComplete(a[7]) +
                    SudokuSudokuXComplete(a[8]) +
                    SudokuSudokuXComplete(a[9]) +
                    SudokuSudokuXComplete(a[10])) == (length(a)))

a = range(57,62)
achievement (
    id = 586704,
    badge = "665207",
    title = "Relax Bro",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5])) == (length(a)))

a = range(64,88)
achievement (
    id = 586705,
    badge = "665208",
    title = "The Hobbit Times",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5])) +
               prev(SudokuSudokuXComplete(a[6])) +
               prev(SudokuSudokuXComplete(a[7])) +
               prev(SudokuSudokuXComplete(a[8])) +
               prev(SudokuSudokuXComplete(a[9])) +
               prev(SudokuSudokuXComplete(a[10])) +
               prev(SudokuSudokuXComplete(a[11])) +
               prev(SudokuSudokuXComplete(a[12])) +
               prev(SudokuSudokuXComplete(a[13])) +
               prev(SudokuSudokuXComplete(a[14])) +
               prev(SudokuSudokuXComplete(a[15])) +
               prev(SudokuSudokuXComplete(a[16])) +
               prev(SudokuSudokuXComplete(a[17])) +
               prev(SudokuSudokuXComplete(a[18])) +
               prev(SudokuSudokuXComplete(a[19])) +
               prev(SudokuSudokuXComplete(a[20])) +
               prev(SudokuSudokuXComplete(a[21])) +
               prev(SudokuSudokuXComplete(a[22])) +
               prev(SudokuSudokuXComplete(a[23])) +
               prev(SudokuSudokuXComplete(a[24]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5]) +
                    SudokuSudokuXComplete(a[6]) +
                    SudokuSudokuXComplete(a[7]) +
                    SudokuSudokuXComplete(a[8]) +
                    SudokuSudokuXComplete(a[9]) +
                    SudokuSudokuXComplete(a[10]) +
                    SudokuSudokuXComplete(a[11]) +
                    SudokuSudokuXComplete(a[12]) +
                    SudokuSudokuXComplete(a[13]) +
                    SudokuSudokuXComplete(a[14]) +
                    SudokuSudokuXComplete(a[15]) +
                    SudokuSudokuXComplete(a[16]) +
                    SudokuSudokuXComplete(a[17]) +
                    SudokuSudokuXComplete(a[18]) +
                    SudokuSudokuXComplete(a[19]) +
                    SudokuSudokuXComplete(a[20]) +
                    SudokuSudokuXComplete(a[21]) +
                    SudokuSudokuXComplete(a[22]) +
                    SudokuSudokuXComplete(a[23]) +
                    SudokuSudokuXComplete(a[24])) == (length(a)))

a = range(90,104)
achievement (
    id = 586706,
    badge = "665210",
    title = "95 Years of Zen",
    description = "Beat Sudokus "+a[0]+" - "+a[length(a)-1]+" on Sudoku X",
    points = 5,
    type = "progression",
    trigger = CompletedPuzzle() &&
              (prev(SudokuSudokuXComplete(a[0])) +
               prev(SudokuSudokuXComplete(a[1])) +
               prev(SudokuSudokuXComplete(a[2])) +
               prev(SudokuSudokuXComplete(a[3])) +
               prev(SudokuSudokuXComplete(a[4])) +
               prev(SudokuSudokuXComplete(a[5])) +
               prev(SudokuSudokuXComplete(a[6])) +
               prev(SudokuSudokuXComplete(a[7])) +
               prev(SudokuSudokuXComplete(a[8])) +
               prev(SudokuSudokuXComplete(a[9])) +
               prev(SudokuSudokuXComplete(a[10])) +
               prev(SudokuSudokuXComplete(a[11])) +
               prev(SudokuSudokuXComplete(a[12])) +
               prev(SudokuSudokuXComplete(a[13])) +
               prev(SudokuSudokuXComplete(a[14]))) == (length(a) - 1) &&
                    (SudokuSudokuXComplete(a[0]) +
                    SudokuSudokuXComplete(a[1]) +
                    SudokuSudokuXComplete(a[2]) +
                    SudokuSudokuXComplete(a[3]) +
                    SudokuSudokuXComplete(a[4]) +
                    SudokuSudokuXComplete(a[5]) +
                    SudokuSudokuXComplete(a[6]) +
                    SudokuSudokuXComplete(a[7]) +
                    SudokuSudokuXComplete(a[8]) +
                    SudokuSudokuXComplete(a[9]) +
                    SudokuSudokuXComplete(a[10]) +
                    SudokuSudokuXComplete(a[11]) +
                    SudokuSudokuXComplete(a[12]) +
                    SudokuSudokuXComplete(a[13]) +
                    SudokuSudokuXComplete(a[14])) == (length(a)))

// Easy Kakuro
KakuroEasyIDs = [591749, 591750, 591751, 591752, 591753, 591754, 591755]
KakuroEasyBadges = ["670580", "670581", "670582", "670583", "670584", "670585", "670586"]
KakuroEasyTitles = ["Kasan Kurosu", "Addition Cross", "Knowledge Is Power", "Using Combinatorics?", "Remember to Take Breaks",
                    "Over Easy", "Easy Peasy Nikoli Me"]
for i in range(0, 6) {
    a = range((i * 15) + 1, (i + 1) * 15)
    achievement (
        id = KakuroEasyIDs[i],
        badge = KakuroEasyBadges[i],
        title = KakuroEasyTitles[i],
        description = "Beat Kakuros "+a[0]+" - "+a[length(a)-1]+" on Easy",
        points = 2,
        trigger = CompletedPuzzle() &&
                  kakuroTrigger(a, "Easy")
    )
}

// Medium Kakuro
KakuroMediumIDs = [591756, 591757, 591758, 591759, 591760, 591761, 591762]
KakuroMediumBadges = ["670587", "670588", "670589", "670590", "670591", "670592", "670593"]
KakuroMediumTitles = ["Known as Cross Sums", "Also as Cross Addition", "Keep at It!", "Using That Math Brain", "Refusing to Slow Down",
                      "On a Roll Now", "Medium Mastery"]
for i in range(0, 6) {
    a = range((i * 15) + 1, (i + 1) * 15)
    achievement (
        id = KakuroMediumIDs[i],
        badge = KakuroMediumBadges[i],
        title = KakuroMediumTitles[i],
        description = "Beat Kakuros "+a[0]+" - "+a[length(a)-1]+" on Medium",
        points = 3,
        trigger = CompletedPuzzle() &&
                  kakuroTrigger(a, "Medium")
    )
}

// Hard Kakuro
KakuroHardIDs = [591763, 591764, 591765, 591766, 591767, 591768, 591769]
KakuroHardBadges = ["670594", "670595", "670596", "670597", "670598", "670599", "670600"]
KakuroHardTitles = ["Knuckle Down Now", "Aiming for the Mastery", "Keen to Finish Them All?", "Unstoppable Force", "Ready for a Few More?",
                      "Only 15 More!", "Hold on, That's It?"]
for i in range(0, 6) {
    a = range((i * 15) + 1, (i + 1) * 15)
    achievement (
        id = KakuroHardIDs[i],
        badge = KakuroHardBadges[i],
        title = KakuroHardTitles[i],
        description = "Beat Kakuros "+a[0]+" - "+a[length(a)-1]+" on Hard",
        points = 5,
        trigger = CompletedPuzzle() &&
                  kakuroTrigger(a, "Hard")
    )
}

// No Hints
//
//
hintIDs = [591770, 591771, 591772, 591773, 591774]
hintBadges = ["670601", "670602", "670603", "670604", "670605"]
hintTitles = ["Hopefully Your First Achievement", "Now with Half the Hints", "Slim Pickings", "Hints Are so Last Week", "Now with Diagonal Rules"]
hintDescriptions = ["Finish an Easy Sudoku or Kakuro puzzle using no hints", 
                    "Finish a Medium Sudoku or Kakuro puzzle using no hints",  
                    "Finish a Hard Sudoku or Kakuro puzzle using no hints", 
                    "Finish a Sudoku on Pro without losing a life", 
                    "Finish a Sudoku on Sudoku X without losing a life"]
hintRemainTriggers = [40, 20, 10, 3, 3]
for i in range(0, 4) {
    achievement (
        id = hintIDs[i],
        badge = hintBadges[i],
        title = hintTitles[i],
        description = hintDescriptions[i],
        points = i + 1,
        trigger = CompletedPuzzleSimplifiedPrev() &&
                  trigger_when(CompletedPuzzleSimplified()) &&
                  CurrentPuzzleLevel() == i &&
                  HintsRemaining() == hintRemainTriggers[i]
    )
}

// Challenges
//
//
challengeIDs = [591781, 591782, 591783, 591784, 591785, 591786]
challengeBadges = ["670612", "670613", "670614", "670615", "670616", "670617"]
challengeTitles = ["Reverse Math", "Is Shipping Still A Thing?", "52 Pickup", "First Choice", "Now for Some Addition", "Watch Your Step"]
challengeDescriptions = ["Subtract", "Pair Match", "Shuffle", "Choice Block", "High Sum", "Mine Detector"]
//old description = "Complete 10 puzzles in a row in the " + challengeDescriptions[i] + " challenge. You must start the challenge from the main menu",
for i in range(0, 5) {
    achievement (
        id = challengeIDs[i],
        badge = challengeBadges[i],
        title = challengeTitles[i],
        description = "Starting from the main menu, complete 10 puzzles in a row in the " + challengeDescriptions[i] + " challenge.",
        points = 5,
        trigger = CurrentChallenge == i &&
                  prev(CurrentChallengeRecord()) == 9 &&
                  CurrentChallengeRecord() == 10
    )
}

// Lessons
//
//
lessonIDs = [591775, 591776, 591777, 591778, 591779, 591780]
lessonBadges = ["670606", "670607", "670608", "670609", "670610", "670611"]
lessonTitles = ["It's Rude", "What About Lone Singles?", "One Dimensional", "Two Dimensional", "Basic Geometry", "Not Invited to the Party"]
lessonDescriptions = ["Pointing", "Naked Pairs", "X-Pattern", "XY-Pattern", "Rectangles", "Exclusion"]

for i in range(0, 5) {
    achievement (
        id = lessonIDs[i],
        badge = lessonBadges[i],
        title = lessonTitles[i],
        description = "Complete Lesson " + (i + 1) + ": " + lessonDescriptions[i],
        points = 1,
        trigger = CompletedPuzzleSimplifiedPrev() &&
                  CompletedPuzzleSimplified() &&
                  LessonLevelCheck(i)
    )
}
// Leaderboards
//
//
