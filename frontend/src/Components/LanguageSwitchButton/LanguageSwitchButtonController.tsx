import { LanguageSwitchButtonView } from "#/Components/LanguageSwitchButton";
import { useAppStore } from "#/store";
import { languages, LanguageSwitchButtonOnMenuClickHandler } from "#/types";
import { useEffect } from "react";

const LanguageSwitchButtonController = () => {
  const { language, setLanguage } = useAppStore();

  const onMenuClick: LanguageSwitchButtonOnMenuClickHandler = (e) => {
    setLanguage(e.key as languages);
  };

  const switchLanguage = () => {
    const _languages = Object.values(languages);
    const index = _languages.indexOf(language);
    const lang = _languages[(index + 1) % _languages.length];
    setLanguage(lang);
  };

  const items = Object.values(languages).map((lang) => ({
    key: lang,
    value: lang,
    label: lang,
  }));
  

  useEffect(() => {
    const _dropdown_items = document.querySelectorAll(
      ".ant-dropdown-menu-item"
    );
    _dropdown_items.forEach((item) => {
      if (item.getAttribute("value") === language) {
        item.classList.add("ant-dropdown-menu-item-selected");
      } else {
        item.classList.remove("ant-dropdown-menu-item-selected");
      }
    });

    return () => {};
  }, [language]);
  return (
    <LanguageSwitchButtonView
      items={items}
      language={language}
      onMenuClick={onMenuClick}
      switchLanguage={switchLanguage}
    />
  );
};

export default LanguageSwitchButtonController;
