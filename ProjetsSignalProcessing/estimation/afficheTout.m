function  afficheTout( p, image_estim )
global image image_sans_bruit p_reel;
subplot(1,3,1), imagesc(image_estim );
subplot(1,3,2), imagesc(image);
subplot(1,3,3), imagesc(image_estim-image_sans_bruit);
p_reel
p
rsi0=rsi(p_reel)
rsi1=rsi(p)
end

