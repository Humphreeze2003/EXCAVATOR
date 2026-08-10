const fs = require("fs");

const inputFile = "text.bin";
const outputFile = "INSTRUCTION_ROM.v";

const data = fs.readFileSync(inputFile);

if (data.length % 4 !== 0) {
    throw new Error(
        `Error: ${data.length} bytes is not divisible by 4.`
    );
}

let output = "";

output += "initial begin\n";

for (let i = 0; i < data.length; i += 4) {

    const instruction =
        data[i] |
        (data[i + 1] << 8) |
        (data[i + 2] << 16) |
        (data[i + 3] << 24);

    const hexInstruction = (instruction >>> 0)
        .toString(16)
        .padStart(8, "0")
        .toUpperCase();

    const romAddress = i / 4;

    output += `    instruction_ROM[${romAddress}] = 32'h${hexInstruction};\n`;
}

output += "end\n";

fs.writeFileSync(outputFile, output);

console.log(`Input size: ${data.length} bytes`);
console.log(`Instructions: ${data.length / 4}`);
console.log(`Output: ${outputFile}`);