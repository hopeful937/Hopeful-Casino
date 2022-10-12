import React, {Component} from 'react'
import Navbar from './ArcadeNavbar.js'
import Web3 from 'web3'
import CoinFlipper from '../build/CoinFlipper.json'
import Main from './Main.js'

class App extends Component {
    constructor(props) {
        super(props)
        this.state = {
            account: '0x0',
            loading: false
        }
    }
    render () {
        let content
        this.state.loading ? content = <p id='loader' className='text-center' style={{margin:'30px'}}>Loading...</p> : content = <Main/>
        return(
            <div>
                <Navbar/>
                <main role='main' className='col-lg-12 ml-auto mr-auto'>
                    <div>
                        {content}
                    </div>
                </main>
            </div>
            
        )
    }
}
export default App;