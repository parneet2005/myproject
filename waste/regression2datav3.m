function [trainingData, responseData]=regression2datav3(t2131bearingDshift_val, DOA_error_val, dopplershift)

trainingData1 = (t2131bearingDshift_val(1:5000,1));

trainingData2 = (t2131bearingDshift_val(1:5000,2));

trainingData3 = (t2131bearingDshift_val(1:5000,3));

if (dopplershift==0)

    trainingData = [trainingData1 trainingData2 trainingData3];

elseif (dopplershift==1)

    trainingData4 = (t2131bearingDshift_val(1:5000,4));

    trainingData = [trainingData1 trainingData2 trainingData3 trainingData4];

end

responseData = DOA_error_val;