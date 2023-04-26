function out = decision_assignment(SAR_A, SAR_B)
    A_D0 = SAR_A(2);
    A_D1 = SAR_A(1);
    B_D0 = SAR_B(2);
    B_D1 = SAR_B(1);
    segment_A = [[A_D1,A_D1,A_D0,0];[0,A_D1,A_D1,A_D0];[A_D0,0,A_D1,A_D1];[A_D1,A_D0,0,A_D1]];
    %segment_A = [A_D1, A_D1,A_D0,0];
    segment_B = [[B_D1,B_D1,B_D0,0];[0,B_D1,B_D1,B_D0];[B_D0,0,B_D1,B_D1];[B_D1,B_D0,0,B_D1]];
    out = [segment_B(randi([1,4]),:), segment_A(randi([1,4]),:)];
end