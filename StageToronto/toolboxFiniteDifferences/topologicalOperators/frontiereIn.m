function answer = frontiereIn(binaryMask, kernel)
answer = binaryMask .* (1-erodePerso(binaryMask, kernel,0.5));