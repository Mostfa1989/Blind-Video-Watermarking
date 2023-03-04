%% Motion Blur Attack 
function motionImageAttacked = motionAttack(watermarked_image)
h = fspecial('motion',4,8);
motionImageAttacked = imfilter(watermarked_image,h,'replicate');
end
