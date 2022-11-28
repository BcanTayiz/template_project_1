import { createSlice } from '@reduxjs/toolkit'
/* Kullanıcının ne kadar miktarda kredisi kaldığını görmesi için oluşturulmuş slice*/
export const creditSlice= createSlice({
  name: 'credit',
  initialState: {
    value: 0
  },
  reducers: {
    assignCredit: (state, action) => {
      state.value = action.payload
    },
  },
})

// Action creators are generated for each case reducer function
export const {assignCredit} = creditSlice.actions

export default creditSlice.reducer