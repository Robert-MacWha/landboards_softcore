package main

import (
	"cpu/cmd/assembler/opcodes"
	"fmt"
	"os"
	"strings"
)

const (
	asmFile     = "instructions/test.asm"
	memFile     = "instructions/test.mem"
	detailsFile = "instructions/test_details.txt"
)

func main() {
	instructions, err := loadInstructions(asmFile)
	if err != nil {
		panic(err)
	}

	err = writeInstructions(memFile, instructions)
	if err != nil {
		panic(err)
	}

	err = writeDetails(detailsFile, instructions)
	if err != nil {
		panic(err)
	}
}

// assemble assembles a list of assembly instructions into a list of machine
// code instructions. The output instructions should be stringified and written
// to a verilog memory initialization file.
func loadInstructions(path string) ([]opcodes.Instruction, error) {
	content, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("ReadFile: %w", err)
	}

	strs := strings.Split(string(content), "\n")

	instructions := make([]opcodes.Instruction, 0, len(strs))
	labels := make(map[string]int)

	// First pass to remove comments
	n := 0
	for _, s := range strs {
		if !strings.HasPrefix(s, "//") {
			strs[n] = s
			n++
		}
	}
	strs = strs[:n]

	// Second pass to store labels
	n = 0
	for _, s := range strs {
		if !strings.HasPrefix(s, ":") {
			strs[n] = s
			n++
		} else {
			labels[s[1:]] = n
		}
	}
	strs = strs[:n]

	// Third pass to parse instructions
	for _, s := range strs {
		instr, err := opcodes.ParseInstruction(s, labels)
		if err != nil {
			return nil, fmt.Errorf("parseInstruction: %w", err)
		}
		instructions = append(instructions, *instr)
	}

	return instructions, nil
}

// writeInstructions writes a list of machine code instructions to a .txt file, each on a new line
func writeInstructions(path string, instructions []opcodes.Instruction) error {
	file, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("Create: %w", err)
	}
	defer file.Close()

	for _, instr := range instructions {
		_, err := file.WriteString(instr.String() + "\n")
		if err != nil {
			return fmt.Errorf("WriteString: %w", err)
		}
	}

	return nil
}

func writeDetails(path string, instructions []opcodes.Instruction) error {
	file, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("Create: %w", err)
	}
	defer file.Close()

	for i, instr := range instructions {
		_, err := file.WriteString(fmt.Sprintf("%v %s\n", i, instr.InfoStr()))
		if err != nil {
			return fmt.Errorf("WriteString: %w", err)
		}
	}

	return nil
}
