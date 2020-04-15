function [ answer ] = askYesOrNo(questionToAsk)
    answer=[];
    while isempty(answer)
        disp([questionToAsk '(enter y for yes, n for no)']);
        answer = input('','s');
         % error of input : we ask again
        if ~strcmp(answer,'y') && ~strcmp(answer,'n')
            answer=[];
            disp('You made an error of input, answer again please :');
        end
    end
    if(strcmp(answer,'y')) % extend the total
        answer=true;
    else
        answer=false; % as it was already but just in case
    end
end

