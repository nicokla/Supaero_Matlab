function result = blurPerso( f, sigma, good )
% Blurs the image only in the zone of good pixels.
% A renormalization is needed to take into acount the artificial
% darkening near the edges
if(sigma==0)
    result=f;
else
    [Mx,My,~]=size(f);
    w=2*ceil(2.5*sigma)+1;
    h=fspecial('gaussian', w, sigma);
    w2=ceil(w/2);
    f = extendImageByConst( f, w2, 0 );
%     result=zeros(size(f));
%    for i=1:size(f,3)
%        result(:,:,i)=cconvForXY( f(:,:,i), h );
%    end
    result=cconvForXY( f, h );
	
    % Compensate around the edges
    good2 = extendImageByConst( good, w2, 0 );
    masque=cconvForXY( good2, h );
    masque(logical(1-good2))=1;
    for i=1:size(f,3)
        result(:,:,i)=result(:,:,i)./masque;
    end
    
    % Compensate for the global loss of energy that will happen when
    % multiplying by the mask "good"
%     coeffGood=sum(sum(masque(logical(good))));
%     coeffBad=sum(sum(masque(logical(1-good))));
%     coeffAll=(coeffGood+coeffBad)/coeffGood;
%     for i=1:size(f,3)
%         result(:,:,i)=result(:,:,i)*coeffAll;
%     end
    
    % Multiplying by the mask "good".
    for i=1:size(f,3)
        result(:,:,i)=result(:,:,i).*good2;
    end
    
    result=keepOnlyCenter( result, w2 );
end



