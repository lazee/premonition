require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  def setup
    dc = Jekyll::Configuration.from({})
    @resources = Jekyll::Premonition::Resources.new(dc)
  end

  def teardown; end

  def test_load_defaults
    cfg = @resources.config
    assert_equal(cfg[:default][:title], nil)
    assert_equal(
      cfg[:default][:template],
      '<div class="premonition {{type}}"><div class="fa {{meta.fa-icon}}"></div>'\
      '<div class="content">{% if header %}<p class="header">{{title}}</p>{% endif %}{{content}}</div></div>'
    )
  end

  def test_load_custom_default
    dc = Jekyll::Configuration.from('premonition' => { 'default' => { 'title' => 'my title', 'template' => '<foo>' } })
    r = Jekyll::Premonition::Resources.new(dc)
    cfg = r.config
    assert_equal(cfg[:default][:title], 'my title')
    assert_equal(cfg[:default][:template], '<foo>')
  end

  def test_load_custom_type_full
    dc = Jekyll::Configuration.from('premonition' =>
    {
      'types' => [
        {
          'id' => 'note',
          'template' => '<bar>',
          'default_title' => 'Default title',
          'meta' => {
            'fa-icon' => 'fa-custom',
            'extra' => 'zot'
          }
        }
      ]
    })
    r = Jekyll::Premonition::Resources.new(dc)
    cfg = r.config
    assert_equal(cfg[:types][0][:id], 'note')
    assert_equal(cfg[:types][0][:template], '<bar>')
    assert_equal(cfg[:types][0][:default_title], 'Default title')
    assert_equal(cfg[:types][0][:meta]['fa-icon'], 'fa-custom')
    assert_equal(cfg[:types][0][:meta]['extra'], 'zot')
  end

  def test_illegal_types_object
    dc = Jekyll::Configuration.from('premonition' =>
    { 'types' => 'string' })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end

  def test_illegal_meta_object
    dc = Jekyll::Configuration.from('premonition' =>
    {
      'types' => [
        {
          'id' => 'note',
          'meta' => []
        }
      ]
    })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end

  def test_illegal_type_id
    dc = Jekyll::Configuration.from('premonition' =>
    { 'types' => [{ 'id' => 'No te' }] })
    assert_raise LoadError do
      Jekyll::Premonition::Resources.new(dc)
    end
  end
end
