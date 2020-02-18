# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class String
  EN = '`qwertyuiop[]asdfghjkl;\'\\zxcvbnm,./~QWERTYUIOP{}ASDFGHJKL:"|ZXCVBNM<>?'
  RU = 'ёйцукенгшщзхъфывапролджэ\\ячсмитьбю.ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,'
  
  def en2ru
    tr(EN, RU)
  end
  
  def ru2en
    tr(RU, EN)
  end
end

if __FILE__ == $0 then
  n = readline.strip.to_i
  n.times { puts readline.en2ru }
end
