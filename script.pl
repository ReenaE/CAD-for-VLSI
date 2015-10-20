

#! /usr/bin/perl

open(INS, "<instructions.txt");
open(BIN, ">instructions.bin");

@lines = <INS>;

foreach $line(@lines){

	chop($line);
	if ($line =~ /OP-IMM\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		print BIN "$words[4]";
		print BIN "$words[3]";
		
		if ($words[2] =~ /ADDI/) {
			print BIN "001";
		}
		if ($words[2] =~ /ANDI/) {
			print BIN "010";
		}
		if ($words[2] =~ /ORI/) {
			print BIN "011";
		}
		if ($words[2] =~ /XORI/) {
			print BIN "100";
		}
		if ($words[2] =~ /SLTI\b/) {
			print BIN "101";
		}
		if ($words[2] =~ /SLTIU\b/) {
			print BIN "110"
		}

		print BIN "$words[1]";
		print BIN "0000001\n";		
	}

	if ($line =~ /JALR\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		print BIN "$words[4]";
		print BIN "$words[3]";
		print BIN "$words[2]";
		print BIN "$words[1]";
		print BIN "0000110\n";
	}

	if ($line =~ /LOAD\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		print BIN "$words[4]";
		print BIN "$words[3]";
		if ($words[2] =~ /LW/) {
			print BIN "001";
		}
		if ($words[2] =~ /LH\b/) {
			print BIN "010";
		}
		if ($words[2] =~ /LHU/) {
			print BIN "011";
		}
		if ($words[2] =~ /LB\b/) {
			print BIN "100";
		}
		if ($words[2] =~ /LBU/) {
			print BIN "101";
		}
		
		print BIN "$words[1]";
		print BIN "0001000\n";
	}


	if ($line =~ /OP\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		if (($words[2] =~ /ADD/) | ($words[2] =~ /SLT/) | ($words[2] =~ /AND/) | ($words[2] =~ /OR/) | ($words[2] =~ /XOR/)) {
			print BIN "0000000";
		}
		if ($words[2] =~ /SLL/) {
			print BIN "0000001";
		}
		if ($words[2] =~ /SRL/) {
			print BIN "0000010";
		}
		if ($words[2] =~ /SUB/) {
			print BIN "1000000";
		}
		if ($words[2] =~ /SRA/) {
			print BIN "0000011";
		}
		print BIN "$words[4]";
		print BIN "$words[3]";
		if ($words[2] =~ /ADD/) {
			print BIN "001";
		}
		if ($words[2] =~ /AND/) {
			print BIN "010";
		}
		if ($words[2] =~ /OR/) {
			print BIN "011";
		}
		if ($words[2] =~ /XOR/) {
			print BIN "100";
		}
		if ($words[2] =~ /SLT\b/) {
			print BIN "101";
		}
		if ($words[2] =~ /SLTU/) {
			print BIN "110";
		}
		if ($words[2] =~ /SLL/) {
			print BIN "001";
		}
		if ($words[2] =~ /SRL/) {
			print BIN "001";
		}
		if ($words[2] =~ /SUB/) {
			print BIN "001";
		}
		if ($words[2] =~ /SRA/) {
			print BIN "001";
		}
		
		print BIN "$words[1]";
		print BIN "0001010\n";
	}

	if ($line =~ /LUI\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		print BIN "$words[2]";
		print BIN "$words[1]";
		print BIN "0000010\n";
	}

	if ($line =~ /AUIPC\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		print BIN "$words[2]";
		print BIN "$words[1]";
		print BIN "0000011\n";
	}

	if ($line =~ /JAL\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		@letters = split("", $words[2]);
		print BIN "$letters[0]";
		for ($j = 10; $j <= 19; $j++) {
			print BIN "$letters[$j]";
		}
		print BIN "$letters[9]";
		for ($k = 1; $k <= 8; $k++) {
			print BIN "$letters[$k]";
		} 
		print BIN "$words[1]";
		print BIN "0000101\n";
	}

	if ($line =~ /BRANCH\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		@letters = split("", $words[4]);
		print BIN "$letters[0]";
		for ($j = 2; $j <= 7; $j++) {
			print BIN "$letters[$j]";
		}
		print BIN "$words[3]";
		print BIN "$words[2]";
		if ($words[1] =~ /BEQ/) {
			print BIN "001";
		}
		if ($words[2] =~ /BNE/) {
			print BIN "010";
		}
		if ($words[2] =~ /BLT\b/) {
			print BIN "011";
		}
		if ($words[2] =~ /BLTU/) {
			print BIN "100";
		}
		if ($words[2] =~ /BGE\b/) {
			print BIN "101";
		}
		if ($words[2] =~ /BGEU/) {
			print BIN "110";
		}
		
		
		for ($k = 8; $k <= 12; $k++) {
			print BIN "$letters[$k]";
		} 
		print BIN "$letters[1]";
		print BIN "0000111\n";
	}

	if ($line =~ /STORE\s\w+/) {
		print "$line \n";
		@words = split(/\ /, $line);
		@letters = split("", $words[4]);
		print BIN "$letters[0]";
		for ($j = 0; $j <= 6; $j++) {
			print BIN "$letters[$j]";
		}
		print BIN "$words[3]";
		print BIN "$words[2]";
		if ($words[1] =~ /SW/) {
			print BIN "001";
		}
		if ($words[2] =~ /SH\b/) {
			print BIN "010";
		}
		if ($words[2] =~ /SHU/) {
			print BIN "011";
		}
		if ($words[2] =~ /SB\b/) {
			print BIN "100";
		}
		if ($words[2] =~ /SBU/) {
			print BIN "101";
		}

		for ($k = 7; $k <= 11; $k++) {
			print BIN "$letters[$k]";
		} 
		print BIN "0001001\n";
	}
}

close INS;
close BIN;








	
