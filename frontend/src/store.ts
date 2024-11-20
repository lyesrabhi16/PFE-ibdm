import { buildStrings, getLanguage } from '#/utils';
import { languages, stringsType } from '#/types';
import { create } from 'zustand';

type Store = {
  language: languages,
  setLanguage: (lang: languages) => void,
  strings: stringsType,
}

export const useAppStore = create<Store>((set) => ({
    language: getLanguage(),
    strings: buildStrings(getLanguage()),
    setLanguage: (lang) => {
        localStorage.setItem("language", lang);
        set({ language: lang});
        set({ strings: buildStrings(lang) });
    },
}))