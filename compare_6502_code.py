"""
This module provides functions to compare two 6502 assembly files and identify differences between them. 
The compare_6502_files function takes two file paths as input and returns a list of differences between the two files.
"""

import re
from typing import List, Dict, Tuple

def compare_6502_files(file1_path: str, file2_path: str) -> List[Tuple[int, List[int]]]:
    """
    Compare two 6502 assembly files and return a list of differences.

    :param file1_path: Path to the first file.
    :param file2_path: Path to the second file.
    :return: A list of tuples containing the starting address and a pair of lists of opcodes that differ.
    """
    def extract_opcodes_from_file(filename: str) -> Dict[int, int]:
        """
        Extract opcodes from a 6502 assembly file and return a dictionary of address to opcode.
        """
        address_opcode_dict = {}
        pattern = r'^([0-9A-Fa-f]{4}):?\s*([0-9A-Fa-f]{2}(?:\s+[0-9A-Fa-f]{2})*)'
        # The line `encodings = ['utf-8', 'latin1', 'cp1252']` is defining a list of encodings that will be
        # used to try reading the file content in different character encodings. The code attempts to open the
        # file using each encoding in the list until it successfully reads the content without any
        # UnicodeDecodeError. This approach helps handle different types of character encodings that the file
        # might be using.
        encodings = ['utf-8', 'latin1', 'cp1252']
        content = None

        for encoding in encodings:
            try:
                with open(filename, 'r', encoding=encoding) as f:
                    content = f.read()
                break
            except UnicodeDecodeError:
                continue

        if content is None:
            try:
                with open(filename, 'rb') as f:
                    content = f.read().decode('ascii', errors='ignore')
            except Exception as e:
                raise Exception(f"Impossible de lire le fichier {filename}: {str(e)}")

        for line in content.split('\n'):
            if not line.strip():
                continue

            if ';' in line:
                line = line.split(';')[0]

            match = re.match(pattern, line.strip())
            if match:
                start_address = int(match.group(1), 16)
                opcodes_str = re.findall(r'[0-9A-Fa-f]{2}', match.group(2))

                # Stocker chaque opcode avec son adresse précise
                for i, op_str in enumerate(opcodes_str):
                    address = start_address + i
                    opcode = int(op_str, 16)
                    address_opcode_dict[address] = opcode

        return address_opcode_dict

    def find_differences_in_opcodes(opcodes_dict1: Dict[int, int], opcodes_dict2: Dict[int, int]) -> List[Tuple[int, List[int]]]:
        """
        Find differences between two dictionaries of opcodes and return a list of tuples containing the starting address and a pair of lists of opcodes that differ.
        """
        differences = []
        common_addresses = sorted(set(opcodes_dict1.keys()) & set(opcodes_dict2.keys()))

        current_diff = None

        for addr in common_addresses:
            if opcodes_dict1[addr] != opcodes_dict2[addr]:
                if current_diff is None:
                    current_diff = (addr, [], [])

                current_diff[1].append(opcodes_dict1[addr])
                current_diff[2].append(opcodes_dict2[addr])
            elif current_diff is not None:
                differences.append(current_diff)
                current_diff = None

        if current_diff is not None:
            differences.append(current_diff)

        return differences

    try:
        opcodes_dict1 = extract_opcodes_from_file(file1_path)
        opcodes_dict2 = extract_opcodes_from_file(file2_path)
        return find_differences_in_opcodes(opcodes_dict1, opcodes_dict2)

    except Exception as e:
        raise Exception(f"Erreur lors de la comparaison des fichiers: {str(e)}")

def print_differences(differences: List[Tuple[int, List[int]]]) -> None:
    if not differences:
        print("\nAucune différence trouvée.")
    else:
        print("\nDifférences trouvées :")
        for start_addr, code1, code2 in differences:
            print(f"Adresses: ${start_addr:04X}-${start_addr + len(code1) - 1:04X}")
            print(f"Fichier 1: {' '.join([f'${x:02X}' for x in code1])}")
            print(f"Fichier 2: {' '.join([f'${x:02X}' for x in code2])}")
            print()

# Exemple d'utilisation
if __name__ == "__main__":
    try:
        file1 = "jungle_hunt_level1_7700_96FF_from_applewin.txt"  # Remplacez par votre chemin de fichier
        #file2 = "junglehunt_A00_to_1eff_and_6000_to_7fff (annoté).asm"  # Remplacez par votre chemin de fich
        file2 = "junglehunt full code (annoté).txt"
        differences = compare_6502_files(file1, file2)
        print_differences(differences)
    except Exception as e:
        print(f"Erreur : {str(e)}")




