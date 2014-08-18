def stripe(payment)
  cents = payment * 100
  percent = 0.029
  flat = 30
  fee = ((cents * percent) + flat) / 100
  "Payment: $#{payment}\nRemaining: $#{payment - fee}\nFee: $#{fee}"
end
puts stripe(5.00)
