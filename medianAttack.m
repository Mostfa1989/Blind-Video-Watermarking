%% Median Attack
function medianImageAttacked = medianAttack(watermarked_image,m)
medianImageAttacked = medfilt2(watermarked_image,[m m]);
end

