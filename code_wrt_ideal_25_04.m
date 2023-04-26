clc;
clear;

%parameters
mu_e =  1 * 2^-12;
mu_w = 1 * 2^-30;

%initializer
R = [];
%del_x = [];

bits = input('Enter no of bits in comparator decision');
total_val = 2^bits;
conversions = input('Enter no of conversion');

%assigning initial digital weights
W_A = zeros(1,total_val);
W_B = zeros(1,total_val);
error_a = zeros(1,total_val);
error_b = zeros(1,total_val);
errors = [0.01 0.02 0.03 0.04 0.05 0.06 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01]*0.1;
for i = 1:total_val
    add_a = errors(randi(length(errors), 1));
    W_A(i) = 1/total_val + add_a;
    error_a(i) = add_a;
%     add_b = errors(randi(length(errors), 1));
    W_B(i) = 1/total_val;
    error_b(i) = 0;
end
init_W_A = W_A;
init_W_B = W_B;

x_A_arr = [];
x_B_arr = [];

e = [transpose(error_b); transpose(error_a)];

x_diff_arr = [];

for iter = 1:conversions
R = [];
comp_A = input('Enter comparator decision A');
comp_B = input('Enter comparator decision B');


magn_a = bi2de(flip(comp_A));
magn_b = bi2de(flip(comp_B));

if(iter == 1)
    flag_a = magn_a;
    flag_b = magn_b;
end

%{
r_init_a = zeros(bits);
r_init_a(end) = 1;
r_init_b = zeros(bits);
r_init_b(end) = 1;
%}

R = [];
R_l = [];

d = decision_logic(comp_A, comp_B);
d_a_unshift = d(total_val+ 1:total_val*2);
d_b_unshift = d(1:total_val);
disp("flag here is")
disp(flag_a);
d_a = circshift(d_a_unshift, flag_a);
d_b = circshift(d_b_unshift, flag_b);
flag_a = mod((flag_a + magn_a), total_val);
flag_b = mod((flag_b + magn_b), total_val);
disp("Flag a is");
disp(flag_a);

R = [d_b d_a*-1];
R_l = [d_b d_a];

i = 0;
while(i < 3 * total_val)
    %if(i != 0) && while(abs(x))
    i = i+1;
    

  %values of x_A and x_B
  %x_A = W_A * transpose(d_a) + transpose(e(5:8))*transpose(d_a);
  %x_B = W_B * transpose(d_b) + transpose(e(1:4))*transpose(d_b);
  x_A = W_A * transpose(d_a);
  x_B = W_B * transpose(d_b);
  error = x_B - x_A;
  %x_diff_arr = [x_diff_arr, error];
  %del_x = [del_x; error];
  del_x = R * e;
  

  %updating errors
  e = (1 - mu_e) * e + mu_e * transpose(R) * del_x;

  %weight correction
  W_A = W_A - mu_w * transpose(e(total_val+1: 2*total_val));
  W_B = W_B - mu_w * transpose(e(1:total_val));
  x_final = (x_A + x_B)/2;
  disp("Final x is")
  disp(x_final)
  x_A_arr = [x_A_arr; x_A];
  x_B_arr = [x_B_arr; x_B];

  %once the error reaches the threshold value of 0.001 the loop terminates
  %{
if(abs(x_A - x_B) <= 0.0001)
      break
  end
  %}
  R_l = [R_l; d_b d_a];
  R = [R; d_b d_a*-1];
end

end
x_final = (x_A + x_B)/2;
%plot(x_diff_arr)

