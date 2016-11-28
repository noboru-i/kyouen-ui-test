Feature: 初期画面から共円まで遊べる
  Scenario: 初期画面から共円まで
    When スプラッシュを待つ
    Then アラートでOKを押す
    Then "TITLE" の "1" が表示されていること
    Then "TITLE_01" としてキャプチャする
    When "TITLE" の "1" をタップする
    Then "KYOUEN_02" としてキャプチャする
