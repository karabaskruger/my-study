function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
M=(X*Theta'-Y).^2;
J=sum(sum(R.*M))/2;
%{
% для X
for i=1:num_movies;
    idx = find(R(i, :)==1); %list of all the users that have rated movie i(row)
    Theta_temp = Theta(idx, :); %матрица
    Y_temp = Y(i, idx); %строка
    X_grad (i, :) = (X(i, :)*Theta_temp'- Y_temp )*Theta_temp ;
end
% для Theta
for i=1:num_users;
    idx = find(R(:, i)==1); %list of all the movies that have rated by user i (column)
    X_temp = X(idx, :);%матрица
    Y_temp = Y(idx,i); %столбец
    Theta_grad (i, :) = (X_temp*Theta(i,:)'- Y_temp )'*X_temp ;
end
% =============================================================
%}
% для X_grad
for i=1:num_movies
  for k=1:num_features
    %сумма
    s=0;
    for m=1:num_users
       if R(i,m)==1
        s=s+(Theta(m,:)*X(i,:)'-Y(i,m))*Theta(m,k);
       endif
    endfor
    X_grad(i,k)=s;
    % конец суммы
  endfor 
endfor
    % для Theta_grad
for j=1:num_users
    for k=1:num_features % !!!!!
      % сумма
      s=0;
      for l=1:num_movies % !!!!!
        if R(l,j)==1
          s=s+(Theta(j,:)*X(l,:)'-Y(l,j))*X(l,k);
        endif
      endfor
      Theta_grad(j,k)=s;
      % конец суммы
    endfor
endfor 
% =============================================================
grad = [X_grad(:); Theta_grad(:)];

end
