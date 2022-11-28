import { createSlice } from '@reduxjs/toolkit'
/* Seçilen country ifadesinin global olarak tutulması için oluşurulmuş slice */
export const selectCountrySlice = createSlice({
  name: 'selectCountry',
  initialState: {
    value: 'TR',
  },
  reducers: {
    select: (state, action) => {
      state.value = action.payload
    },
  },
})

// Action creators are generated for each case reducer function
export const {select} = selectCountrySlice.actions

export default selectCountrySlice.reducer