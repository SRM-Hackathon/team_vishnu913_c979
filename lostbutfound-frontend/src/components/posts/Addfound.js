import React, { useState, useContext, useEffect } from 'react'
import Mymap from '../helpers/Mymap'
import { Modal, Button } from 'react-materialize'
import '../../App.css'
import authContext from '../../context/Auth/authContext'

//des,lat,long,name,img
const Addfound = props => {
	const { loaduser } = useContext(authContext)
	const trigger = <Button>Open Modal</Button>

	const [fstate, setfstate] = useState({
		name: '',
		lat: '',
		lng: '',
		file: null,
		desc: ''
	})

	const _onchange = e => {
		setfstate({
			...fstate,
			[e.target.name]: e.target.value
		})
	}

	const toBase64 = file =>
		new Promise((resolve, reject) => {
			const reader = new FileReader()
			reader.readAsDataURL(file)
			reader.onload = () => resolve(reader.result)
			reader.onerror = error => reject(error)
		})

	const onFormSubmit = async e => {
		console.log('started submitting')
		e.preventDefault() // Stop form submit
		console.log('started submitting')

		//send req
		const url = 'http://192.168.43.46:8000/found/'

		const formData = new FormData()
		formData.append('image', await toBase64(fstate.file))
		formData.append('name', fstate.name)
		formData.append('description', fstate.desc)
		formData.append('latitude', fstate.lat)
		formData.append('longitude', fstate.lng)

		const config = {
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
				'Authorization': localStorage.getItem('token').trim()
			}
		}
		console.log(config.headers)

		fetch(url, {
			body: formData,
			method: 'post',
			config: config.headers
		}).then(result => {
			props.history.push('/test')
		})
	}
	const onChange = e => {
		setfstate({ ...fstate, file: e.target.files[0] })
	}
	useEffect(() => {
		loaduser()
	}, [])

	return (
		<div>
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
							<b>FOUND</b>
						</span>
						<div style={{ marginTop: '20%' }}>
							<div class='file-field input-field'>
								<div class='btn'>
									<span>File</span>
									<input type='file' onChange={onChange} />
								</div>
								<div class='file-path-wrapper'>
									<input
										class='file-path validate'
										type='text'
										placeholder='Upload one or more files'
									/>
								</div>
							</div>
							<div class='input-field col s6'>
								<input
									placeholder='Person Name..'
									id='name'
									type='text'
									class='validate'
									name='name'
									value={fstate.name}
									onChange={_onchange}
								/>
								<label for='first_name'></label>
							</div>
							<div class='input-field col s6'>
								<textarea
									rows='4'
									cols='50'
									placeholder='Description..'
									name='desc'
									value={fstate.desc}
									onChange={_onchange}
								></textarea>
							</div>
							<div>
								<Button href='#modal1' className='modal-trigger'>
									Select Location
								</Button>
								<Modal
									id='modal1'
									header='choose your location'
									style={{ maxHeight: '100%' }}
								>
									<Mymap data={{ fstate, setfstate }} />
								</Modal>
							</div>
							<div style={{ marginTop: '15%' }}>
								<button
									onClick={onFormSubmit}
									className='waves-effect waves-light btn-large z-depth-3'
									style={{
										width: '50%',
										borderRadius: '500px',
										background: 'linear-gradient(to right, #8e2de2, #4a00e0)'
									}}
								>
									Submit
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	)
}

export default Addfound
