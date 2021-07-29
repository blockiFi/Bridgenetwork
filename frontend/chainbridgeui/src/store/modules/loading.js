const state = {
    status: true
}

const getters = {}
const actions = {
   activateLoader( {commit} , status){
     commit('setLoader' , status);
    }
}

const mutations = {
    setLoader (state , status){
        state.status = status;
    }
};

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}