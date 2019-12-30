function x = randlpl(mu, b, m, n)

    x = mu - b*sign(rand(m,n)-0.5).*log(1-2*abs(rand(m,n)-0.5));

end