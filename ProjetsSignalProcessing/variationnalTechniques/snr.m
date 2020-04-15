function result = snr( imageReelle, imageBruitee )
noise=imageBruitee-imageReelle;
noise_norm=norm(noise,'fro');
signal_norm=norm(imageReelle,'fro');
result=signal_norm/noise_norm;
result=20*log10(result);
end

