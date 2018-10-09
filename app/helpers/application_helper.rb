module ApplicationHelper
  def html_classes(classes)
    content_for(:html_classes) { classes }
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def description(page_description)
    content_for(:description) { page_description }
  end

  def pdf_logo_tag(name)
    image_tag image_url(name)
  end

  def order_item_title(order_item)
    if order_item.product == "DigitalCard"
      case order_item.subtype
      when "regular"
        "Gåvobevis - digitalt"
      when "regular-company"
        "Gåvobevis - digitalt"
      when "regular-company-english"
        "Gåvobevis (engelska) - digitalt"
      when "xmas"
        "Julgåvobevis - digitalt"
      when "xmas2"
        "Julgåvobevis 2 - digitalt"
      when "xmas-company"
        "Julgåvobevis - digitalt"
      when "xmas-company-english"
        "Julgåvobevis (engelska) - digitalt"
      end
    elsif order_item.product == "AnalogCard"
      case order_item.subtype
      when "regular-company"
        "Gåvobevis - tryckt"
      when "regular"
        "Gåvobevis - tryckt"
      when "xmas"
        "Julgåvobevis - tryckt"
      when "xmas-company"
        "Julgåvobevis - tryckt"
      end
    elsif order_item.product == "Extra"
      "Extra gåva"
    end
  end

  def card_title(card)
    if card.class.model_name == "DigitalCard"
      case card.subtype
      when nil
        "Gåvobevis - digitalt"
       when "regular"
        "Gåvobevis - digitalt"
      when "regular-company"
        "Gåvobevis - digitalt"
      when "regular-company-english"
        "Gåvobevis (engelska) - digitalt"
      when "xmas"
        "Julgåvobevis - digitalt"
      when "xmas2"
        "Julgåvobevis - digitalt"
      when "xmas-company"
        "Julgåvobevis - digitalt"
       when "xmas-company-english"
        "Julgåvobevis (engelska) - digitalt"
      end
    elsif card.class.model_name == "AnalogCard"
      case card.subtype
      when nil
        "Gåvobevis - tryckt"
      when "regular"
        "Gåvobevis - tryckt"
      when "xmas"
        "Julgåvobevis - tryckt"
      when "regular-company"
        "Gåvobevis - tryckt"
      when "xmas-company"
        "Julgåvobevis - tryckt"
      end
    elsif card.class.model_name == "Extra"
      "Extra gåva"
    end
  end
end
