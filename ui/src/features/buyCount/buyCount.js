import { createSlice } from '@reduxjs/toolkit'
/* Kullanıcının ne kadar miktarda kare alacağını belirtmesi için oluşturulmuş slice */
export const BuyCountSlice = createSlice({
  name: 'buyCount',
  initialState: {
    value: 0
  },
  reducers: {
    assignBuyCount: (state, action) => {
      state.value = action.payload
    },
  },
})

// Action creators are generated for each case reducer function
export const {assignBuyCount} = BuyCountSlice.actions

export default BuyCountSlice.reducer