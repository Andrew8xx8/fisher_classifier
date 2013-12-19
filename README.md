# FisherClassifier

Реализация статистического классификатора докуметов на основе линейного дискриминанта Фишера.

Предоставляет прозрачный DSL для кофигурирования с возможностью определить:

* набор категорий;
* способ определения признаков;
* коэффициент для подсчета взвешенной вероятности;
* минимальный порог для определения принадлежности к категории;
* любое хранилище статистики.

Подробнее с теорией:
* [Баесовский классификатор](http://www.machinelearning.ru/wiki/index.php?title=%D0%91%D0%B0%D0%B9%D0%B5%D1%81%D0%BE%D0%B2%D1%81%D0%BA%D0%B8%D0%B9_%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80)
* [Линейный дискриминант Фишера](http://www.machinelearning.ru/wiki/index.php?title=%D0%9B%D0%B8%D0%BD%D0%B5%D0%B9%D0%BD%D1%8B%D0%B9_%D0%B4%D0%B8%D1%81%D0%BA%D1%80%D0%B8%D0%BC%D0%B8%D0%BD%D0%B0%D0%BD%D1%82_%D0%A4%D0%B8%D1%88%D0%B5%D1%80%D0%B0)

## Установка

Добавить в Gemfile:

    gem 'fisher_classifier'

Выполнить:

    $ bundle

Или поставить как гем:

    $ gem install fisher_classifier

## Try Before You Buy™

Попробовать можно в консоли, вот так:

    $ irb

    1.9.3-p448 :002 > require 'fisher_classifier'
    1.9.3-p448 :003 > cl = FisherClassifier.create_in_memory
    1.9.3-p448 :005 > cl.train('Nobody owns the water.','good')
    => ["Nobody", "owns", "the", "water."]
    1.9.3-p448 :006 > cl.train('the quick rabbit jumps fences','good')
    => ["the", "quick", "rabbit", "jumps", "fences"]
    1.9.3-p448 :007 > cl.train('buy pharmaceuticals now','bad')
    => ["buy", "pharmaceuticals", "now"]
    1.9.3-p448 :008 > cl.train('make quick money at the online casino','bad')
    => ["make", "quick", "money", "at", "the", "online", "casino"]
    1.9.3-p448 :009 > cl.train('the quick brown fox jumps','good')
    => ["the", "quick", "brown", "fox", "jumps"]
    1.9.3-p448 :015 >  cl.train('online trading with forex','bad')
     => ["online", "trading", "with", "forex"]
    1.9.3-p448 :008 > cl.classify('the quick money with forex now')
    => :bad
    1.9.3-p448 :009 > cl.classify('quck mouse runs from fox')
    => :good

В данном примере в качестве хранилища используется оперативная память.

## DSL

### Определениепризнаков

```ruby
  get_features do |text|
    # Выделить набор признаков из текста
  end
```

### Обучение

```ruby
  inc_feature do |feature, category|
    # Увеличить счетчик кол-ва использований признака в категории
  end

  inc_category do |category|
    # Увеличить счетчик кол-ва использований категории
  end
```

### Классификация

```ruby
  # Предполагаемая вероятность (Вероятность признака, если он ни разу не появлялся)
  assumed_prob 0.4

  # Порог. Минимальное значение вероятности принадлежности текста в категории
  fisher_threshold 0.1

  categories do
    # Возможные категории
  end

  category_count do |category|
    # Кол-во использований категории
  end

  features_count do |feature, category|
    # Кол-во использований признака в категории
  end

  default_category do
    # Категория по умолчанию
  end
```

## Rails (Active Record)

Миграция (db/migrate/20131106143644_create_classifier_features.rb):

```ruby
class CreateClassifierFeatures < ActiveRecord::Migration
  def change
    create_table :classifier_features do |t|
      t.string :name
      t.string :category
      t.integer :count, default: 1
    end
  end
end
```

Модель (app/models/classifier_feature.rb):

```ruby
class ClassifierFeature < ActiveRecord::Base
  validates :category, presence: true
  validates :name, presence: true, uniqueness: {:scope => :category}

  def self.categories
    [:good, :bad]
  end
end
```

Инициалайзер:

[config/initializers/classifier.rb](https://github.com/Andrew8xx8/fisher_classifier/blob/master/examples/classifier_initializer.rb)

Использование:

    $ rails c
    1.9.3-p448 :009 > Classifier.train('the quick brown fox jumps', :good)
    1.9.3-p448 :009 > Classifier.classify('the quick brown fox jumps', :good)

## Если хочется что-то исправить

1. Форкни
2. Зафигач фиче-ветку (`git checkout -b my-new-feature`)
3. Коммить изменения (`git commit -am 'Add some feature'`)
4. Пуш ветку (`git push origin my-new-feature`)
5. Create new Pull Request
