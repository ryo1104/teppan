import $ from 'jquery';
require('selectize');

const url = (query) => {
  return `/neta/tag_search_autocomplete?keyword=${encodeURIComponent(query)}`
};

const items = (data) => {
  return data.map((item) => {
    return {
      text: item['attributes']['hashname'],
      sub_text: item['attributes']['hiragana'], // ひらがなでも検索結果を絞り込めるようにする
      label: "#"+item['attributes']['hashname'],
      value: item['attributes']['hashname']
    }
  })
};

const getAutocomplete = (query, callback) => {
  $.ajax({
    url: url(query),
    type: 'GET',
    error: () => {
      callback()
    },
    success: (res) => {
      callback(items(res.data))
    }
  })
};


const renderOption = (item, escape) => {
  return `<div><span>${escape(item.text ? "#"+item.text : '')}</span></div>`
};

const renderOptionCreate = (item, escape) => {
  return `<div><span>${escape(item.input) ? item.input : ''}</span></div>`
};

const searchSelectize = () => {
  $('#tag_search_field').selectize({
    searchField: ['text', 'sub_text'], // 入力値のフィルター対象、ひらがなでも検索結果を絞り込めるようにする
    labelField: 'label', // 表示させるラベル
    valueField: 'value', // inputのvalue
    closeAfterSelect: true,
    create: true, // 新規単語を追加を許可
    createOnBlur: true, // 画面外をタッチすると新規単語を追加
    maxItems: 1,
    loadThrottle: 500,
    placeholder: 'キーワードを入力',
    load: (query, callback) => {
      if (!query.length) return callback();
      getAutocomplete(query, callback)
    },
    render: {
      option: (item, escape) => {
        return renderOption(item, escape)
      },
      option_create: (item, escape) => {
        return renderOptionCreate(item, escape)
      }
    }
  })
};


const addSelectize = () => {
  $('#tag_post_field').selectize({
    searchField: ['text', 'sub_text'], // 入力値のフィルター対象、ひらがなでも検索結果を絞り込めるようにする
    labelField: 'label', // 表示させるラベル
    valueField: 'value', // inputのvalue
    closeAfterSelect: true,
    create: true, // 新規単語を追加を許可
    createOnBlur: true, // 画面外をタッチすると新規単語を追加
    delimiter: ',',
    maxItems: 20,
    loadThrottle: 500,
    placeholder: 'ハッシュタグ',
    load: (query, callback) => {
      if (!query.length) return callback();
      getAutocomplete(query, callback)
    },
    render: {
      option: (item, escape) => {
        return renderOption(item, escape)
      },
      option_create: (item, escape) => {
        return renderOptionCreate(item, escape)
      }
    }
  })
};

const initialize = function () {
  searchSelectize();
  addSelectize();
};

window.onload = function () {
  initialize();
};