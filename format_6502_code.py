def format_asm_code(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            # Ignore empty lines
            if line.strip():
                # Split the line into components
                parts = line.split()

                # Address is the first part, remove the ':'
                address = parts[0].replace(':', '')

                # Extract opcodes (1, 2 or 3 bytes max), based on the number of hexadecimal values
                opcodes = []
                for part in parts[1:]:
                    if len(part) == 2 and all(c in '0123456789ABCDEFabcdef' for c in part):
                        opcodes.append(part)
                    else:
                        break
                
                # Join opcodes into a string
                opcodes_str = ' '.join(opcodes)

                # The rest of the line after the opcodes is the instruction
                instruction = ' '.join(parts[len(opcodes)+1:]).upper()

                # Calculate spaces to align instruction
                spaces_needed = 12 - len(opcodes_str)  # At least 4 spaces after opcodes

                # Format the line
                formatted_line = f"{address}:{opcodes_str}{' ' * spaces_needed}{instruction}\n"
                
                outfile.write(formatted_line)
                
filein="7700-96ff.txt"                
format_asm_code(filein, "format_"+filein)