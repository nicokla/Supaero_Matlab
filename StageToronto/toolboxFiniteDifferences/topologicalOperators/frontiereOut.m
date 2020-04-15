function answer = frontiereOut(binaryMask, kernel)
answer = (1-binaryMask) .* dilatePerso(binaryMask, kernel, 0.5);

