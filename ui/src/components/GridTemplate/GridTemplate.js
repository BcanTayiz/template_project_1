import React from 'react'

import './gridTemplate.css'
import GridSquare from './GridSquare/GridSquare'





export default function GridTemplate() {

    const grid = []
    /* gridleri oluşturmak için https://makeschool.org/mediabook/oa/tutorials/react-redux-tetris-app-tutorial-o4s/tetris-grid/
    websitesinden yararlandım. 50'ye 50 bir şekilde oluşturup compnent olarak alıyorum  */
    for (let row = 0; row < 50; row ++) {
        grid.push([])
        for (let col = 0; col < 50; col ++) {
            grid[row].push(<GridSquare key={`${col}${row}`} color="1" />)
        }
    }

  return (
    <div className='grid-main'>GridTemplate
        <main className='grid-board'>
            {/* burada da compnent olarak grid listesini değer */}
            {grid}
        </main>
    </div>
  )
}
