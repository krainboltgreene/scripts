total_likes = 100
total_dislikes = 8
total_score = 108
MODIFIER = 1.96

z = 1.96
n = total_likes + total_dislikes
phat = total_likes / n.to_f
score = (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)



    phat = total_likes / total_score.to_f
    a = 1 - phat
    b = 4 * total_score
    c = MODIFIER * MODIFIER
    d = c / b
    e = phat * a
    f = e + d
    g = f / total_score
    h = Math.sqrt g
    i = 2 * total_score
    j = c / i
    k = MODIFIER * h
    l = phat + j
    m = l - k
    n = c / total_score
    o = 1 + n
    score2 = m / o

puts score == score2
