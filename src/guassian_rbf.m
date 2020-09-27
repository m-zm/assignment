function value = guassian_rbf(dist, sigma2)

value = exp(-dist./sigma2);
