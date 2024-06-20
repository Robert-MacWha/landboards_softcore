package opcodes

import (
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
)

type OP byte

type Instruction struct {
	Opcode   OP
	Register string
	Value    string
	Comment  string
}

const (
	LRI OP = 2  // Load register with immediate value
	IOW OP = 6  // I/O write from register
	IOR OP = 7  // I/O read from register
	ARI OP = 8  // AND register with immediate value
	BEZ OP = 12 // Branch if zero
	BNZ OP = 13 // Branch if not zero
	JMP OP = 14 // Jump to address
	NOP OP = 16 // No operation
)

var OpNames = map[OP]string{
	LRI: "LRI",
	IOW: "IOW",
	IOR: "IOR",
	ARI: "ARI",
	BEZ: "BEZ",
	BNZ: "BNZ",
	JMP: "JMP",
	NOP: "NOP",
}

func (o OP) String() string {
	opStr := strconv.FormatInt(int64(o), 2)
	opStr = fmt.Sprintf("%0*s", 4, opStr)
	return opStr
}

func (i Instruction) String() string {
	return fmt.Sprintf("%s%s%s", i.Opcode, i.Register, i.Value)
}

func (i Instruction) InfoStr() string {
	return fmt.Sprintf("%s %s %s %s", OpNames[i.Opcode], i.Register, i.Value, i.Comment)
}

func ParseInstruction(str string, labels map[string]int) (*Instruction, error) {
	splitStr := strings.Split(str, " ")
	if len(splitStr) == 0 {
		return nil, fmt.Errorf("empty instruction")
	}

	op, err := parseOp(splitStr[0])
	if err != nil {
		return nil, fmt.Errorf("parse: %w", err)
	}

	instruction := Instruction{
		Opcode: op,
	}

	switch op {
	case LRI, IOW, IOR, ARI:
		if len(splitStr) < 3 {
			return nil, fmt.Errorf("not enough arguments")
		}
		reg, err := parseBits(4, splitStr[1])
		if err != nil {
			return nil, fmt.Errorf("parseBits(%v): %w", splitStr[1], err)
		}

		val, err := parseBits(8, splitStr[2])
		if err != nil {
			return nil, fmt.Errorf("parseBits(%v): %w", splitStr[2], err)
		}

		instruction.Register = reg
		instruction.Value = val
		instruction.Comment = strings.Join(splitStr[3:], " ")
	case BEZ, BNZ, JMP:
		if len(splitStr) < 2 {
			return nil, fmt.Errorf("not enough arguments")
		}

		label := splitStr[1]
		intAddr, ok := labels[label]
		if !ok {
			return nil, fmt.Errorf("unknown label: %v", label)
		}

		addr := strconv.FormatInt(int64(intAddr), 2)
		addr, err := parseBits(12, "b"+addr)
		if err != nil {
			return nil, fmt.Errorf("parseBits(%v): %w", addr, err)
		}

		instruction.Value = addr
		instruction.Comment = strings.Join(splitStr[2:], " ")
	}

	return &instruction, nil
}

func parseOp(s string) (OP, error) {
	for op, name := range OpNames {
		if name == s {
			return op, nil
		}
	}
	return 0, fmt.Errorf("unknown opcode: %v", s)
}

func parseBits(n int, s string) (string, error) {
	var binStr string

	switch s[0] {
	case 'h': // Hexadecimal
		b, err := hex.DecodeString(s[1:])
		if err != nil {
			return "", fmt.Errorf("DecodeString: %w", err)
		}

		if len(b) > 1 {
			return "", fmt.Errorf("expected 1 byte, got %d", len(b))
		}

		binStr = fmt.Sprintf("%08b", b[0])

	case 'b', '0', '1': // Binary
		binStr = s[1:]
		for _, c := range binStr {
			if c != '0' && c != '1' {
				return "", fmt.Errorf("invalid char in binary string: %v", c)
			}
		}

	default:
		return "", fmt.Errorf("invalid prefix, expected 'h' or 'b'")
	}

	// Length assertion
	if len(binStr) > n {
		return "", fmt.Errorf("value exceeds %d bits", n)
	}

	// Zero padding
	binStr = fmt.Sprintf("%0*s", n, binStr)

	return binStr, nil
}
