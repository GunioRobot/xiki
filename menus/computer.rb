# Is just a menu now, since it's all delegation


class Computer

  def self.menu
    "
    - .ip/
    - @processes/
    "
  end

  def self.ip
    txt = `ifconfig`
    inet = txt.grep(/\binet\b/)

    return "| #{inet[0][/[\d.]+/]}\n- apparently you\'re not connected to the internet?!" if inet.length < 2

    "| #{inet[1][/[\d.]+/]}"
  end

end
