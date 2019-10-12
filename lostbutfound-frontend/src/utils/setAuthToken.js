import axios from 'axios'

const setAuthToken = token => {
	if (token) {
		axios.defaults.headers.common['Authorization'] = 'token ' + token
		//Authorization:Token[auth token]
	} else {
		delete axios.defaults.headers.common['Authorization']
	}
}

export default setAuthToken
