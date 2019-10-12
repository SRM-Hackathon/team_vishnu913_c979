import React, { useEffect, useContext, useState } from 'react'
import authContext from '../../context/Auth/authContext'

export const Logincard = props => {
	const { login, isAuthenticated, loaduser } = useContext(authContext)

	const [state, setstate] = useState({
		email: '',
		password: ''
	})

	const _onchange = e => {
		setstate({
			...state,
			[e.target.name]: e.target.value
		})
	}

	const _onsubmit = e => {
		e.preventDefault()
		console.log('submitted')
		login(state)
	}

  useEffect(() => {
    loaduser()
		if (isAuthenticated) {
			props.history.push('/myposts')
		}
		//eslint-disable-next-line
	}, [isAuthenticated])

	return (
		<div
			className='container'
			style={{ position: 'absolute', left: '35%', top: '20%' }}
		>
			<div
				className='card z-depth-5  '
				style={{ width: '30rem', height: '70vh', borderRadius: '10px' }}
			>
				<div className='card-content ' style={{ textAlign: 'center' }}>
					<span className='card-title'>
						<b>LOGIN</b>{' '}
					</span>
					<div style={{ marginTop: '20%' }}>
						<div className='input-field col s12'>
							<input
								id='email'
								type='email'
								className='validate'
								name='email'
								value={state.email}
								onChange={_onchange}
							/>
							<label htmlFor='email'>Email</label>
						</div>
						<div className='input-field col s12' style={{ marginTop: '50px' }}>
							<input
								id='password'
								type='password'
								name='password'
								className='validate'
								value={state.password}
								onChange={_onchange}
							/>
							<label htmlFor='password'>Password</label>
						</div>
						<div style={{ marginTop: '15%' }}>
							<button
								onClick={_onsubmit}
								className='waves-effect waves-light btn-large z-depth-3'
								style={{
									width: '50%',
									borderRadius: '500px',
									background: 'linear-gradient(to right, #8e2de2, #4a00e0)'
								}}
							>
								login
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	)
}
